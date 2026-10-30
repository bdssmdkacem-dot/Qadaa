import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qadaa/qadaa_data.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('migrates existing count-only progress without losing it', () async {
    SharedPreferences.setMockInitialValues({'qadaa.completed': 7});

    final snapshot = await QadaaPrayerStore.load();

    expect(snapshot.legacyCompleted, 7);
    expect(snapshot.records, isEmpty);
    expect(snapshot.completedCount, 7);

    await QadaaPrayerStore.save(snapshot);
    final reloaded = await QadaaPrayerStore.load();
    expect(reloaded.completedCount, 7);
  });

  test('persists each prayer record and restores newest records first', () async {
    final older = PrayerRecord(
      prayer: 'fajr',
      completedAt: DateTime.utc(2026, 10, 20, 6),
    );
    final newer = PrayerRecord(
      prayer: 'isha',
      completedAt: DateTime.utc(2026, 10, 21, 20),
    );
    final snapshot = const QadaaPrayerStoreSnapshot(
      legacyCompleted: 2,
      records: [],
    ).add(older).add(newer);

    await QadaaPrayerStore.save(snapshot);
    final restored = await QadaaPrayerStore.load();

    expect(restored.completedCount, 4);
    expect(restored.records.map((record) => record.prayer), ['isha', 'fajr']);
    expect(restored.records.first.completedAt, newer.completedAt);
  });

  test('round-trips a record through JSON', () {
    final record = PrayerRecord(
      prayer: 'dhuhr',
      completedAt: DateTime.utc(2026, 10, 29, 12, 30),
    );

    expect(
      PrayerRecord.fromJson(record.toJson()).toJson(),
      record.toJson(),
    );
  });

  test('damaged or unknown prayer records do not crash startup', () async {
    SharedPreferences.setMockInitialValues({
      'qadaa.legacyCompleted': 3,
      'qadaa.prayerRecords':
          '[{"prayer":"not-a-prayer","completedAt":"2026-01-01T00:00:00.000Z"}]',
    });
    final snapshot = await QadaaPrayerStore.load();
    expect(snapshot.legacyCompleted, 3);
    expect(snapshot.records, isEmpty);
    expect(snapshot.completedCount, 3);
  });

  test('empty history does not discard migrated legacy progress', () async {
    SharedPreferences.setMockInitialValues({
      'qadaa.completed': 8,
      'qadaa.prayerRecords': '[]',
    });
    final snapshot = await QadaaPrayerStore.load();
    expect(snapshot.legacyCompleted, 8);
    expect(snapshot.records, isEmpty);
  });

  test('malformed JSON history is ignored without losing legacy progress', () async {
    SharedPreferences.setMockInitialValues({
      'qadaa.legacyCompleted': 11,
      'qadaa.prayerRecords': '[{"prayer":',
    });

    final snapshot = await QadaaPrayerStore.load();

    expect(snapshot.legacyCompleted, 11);
    expect(snapshot.records, isEmpty);
    expect(snapshot.completedCount, 11);
  });

  test('invalid timestamps and non-list history do not crash startup', () async {
    SharedPreferences.setMockInitialValues({
      'qadaa.legacyCompleted': 5,
      'qadaa.prayerRecords':
          '[{"prayer":"fajr","completedAt":"not-a-date"}]',
    });

    final invalidTimestamp = await QadaaPrayerStore.load();
    expect(invalidTimestamp.completedCount, 5);
    expect(invalidTimestamp.records, isEmpty);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qadaa.prayerRecords', '{"prayer":"fajr"}');

    final nonList = await QadaaPrayerStore.load();
    expect(nonList.completedCount, 5);
    expect(nonList.records, isEmpty);
  });
}
