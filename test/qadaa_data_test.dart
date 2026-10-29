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
}
