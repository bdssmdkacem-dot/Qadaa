import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A single manually logged make-up prayer. Timestamps are stored in UTC.
class PrayerRecord {
  const PrayerRecord({required this.prayer, required this.completedAt});

  final String prayer;
  final DateTime completedAt;

  Map<String, Object?> toJson() => {
        'prayer': prayer,
        'completedAt': completedAt.toUtc().toIso8601String(),
      };

  factory PrayerRecord.fromJson(Map<String, Object?> json) {
    final prayer = json['prayer'];
    final completedAt = json['completedAt'];
    if (prayer is! String || completedAt is! String) {
      throw const FormatException('Invalid Qadaa prayer record');
    }
    return PrayerRecord(
      prayer: prayer,
      completedAt: DateTime.parse(completedAt).toUtc(),
    );
  }
}

/// Local-first persistence for prayer records and older count-only installations.
class QadaaPrayerStore {
  QadaaPrayerStore._();

  static const recordsKey = 'qadaa.prayerRecords';
  static const legacyCompletedKey = 'qadaa.legacyCompleted';

  static Future<QadaaPrayerStoreSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getInt(legacyCompletedKey) ??
        (prefs.containsKey(recordsKey) ? 0 : (prefs.getInt('qadaa.completed') ?? 0));
    if (!prefs.containsKey(legacyCompletedKey)) {
      await prefs.setInt(legacyCompletedKey, legacy);
    }

    final raw = prefs.getString(recordsKey);
    if (raw == null || raw.isEmpty) {
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const FormatException('Prayer records must be a list');
      }
      final records = decoded
          .whereType<Map<String, dynamic>>()
          .map(PrayerRecord.fromJson)
          .toList()
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: records);
    } on FormatException {
      // Preserve the user's app state and surface an empty record list rather
      // than crashing startup on a damaged optional history value.
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    } on TypeError {
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    }
  }

  static Future<void> save(QadaaPrayerStoreSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(legacyCompletedKey, snapshot.legacyCompleted);
    await prefs.setString(
      recordsKey,
      jsonEncode(snapshot.records.map((record) => record.toJson()).toList()),
    );
    await prefs.setInt('qadaa.completed', snapshot.completedCount);
  }
}

class QadaaPrayerStoreSnapshot {
  const QadaaPrayerStoreSnapshot({
    required this.legacyCompleted,
    required this.records,
  });

  final int legacyCompleted;
  final List<PrayerRecord> records;

  int get completedCount => legacyCompleted + records.length;

  QadaaPrayerStoreSnapshot add(PrayerRecord record) => QadaaPrayerStoreSnapshot(
        legacyCompleted: legacyCompleted,
        records: [record, ...records],
      );
}
