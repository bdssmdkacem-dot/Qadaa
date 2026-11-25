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
    if (prayer is! String ||
        !const {'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'}.contains(prayer) ||
        completedAt is! String) {
      throw const FormatException('Invalid Qadaa prayer record');
    }
    try {
      return PrayerRecord(
        prayer: prayer,
        completedAt: DateTime.parse(completedAt).toUtc(),
      );
    } on FormatException {
      throw const FormatException('Invalid Qadaa prayer timestamp');
    }
  }
}

/// Local-first persistence for prayer records and older count-only installations.
class QadaaPrayerStore {
  QadaaPrayerStore._();

  static const recordsKey = 'qadaa.prayerRecords';
  static const legacyCompletedKey = 'qadaa.legacyCompleted';
  static const maxHistoryBytes = 4 * 1024 * 1024;
  static const maxRecords = 100000;

  static Future<QadaaPrayerStoreSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getInt(legacyCompletedKey) ??
        (prefs.getInt('qadaa.completed') ?? 0);
    if (!prefs.containsKey(legacyCompletedKey)) {
      await prefs.setInt(legacyCompletedKey, legacy);
    }

    final raw = prefs.getString(recordsKey);
    if (raw == null || raw.isEmpty) {
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    }

    try {
      if (raw.length > maxHistoryBytes) {
        throw const FormatException('Prayer history exceeds the supported size');
      }
      final decoded = jsonDecode(raw);
      if (decoded is! List || decoded.length > maxRecords) {
        throw const FormatException('Prayer history has an invalid size');
      }
      final records = decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid Qadaa prayer record');
        }
        return PrayerRecord.fromJson(item);
      }).toList();
      _rejectDuplicateRecords(records);
      records.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: records);
    } on FormatException {
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    } on TypeError {
      return QadaaPrayerStoreSnapshot(legacyCompleted: legacy, records: const []);
    }
  }

  static Future<void> save(QadaaPrayerStoreSnapshot snapshot) async {
    if (snapshot.records.length > maxRecords) {
      throw ArgumentError('Prayer history exceeds the supported record limit');
    }
    _rejectDuplicateRecords(snapshot.records);
    final encoded = jsonEncode(snapshot.records.map((record) => record.toJson()).toList());
    if (encoded.length > maxHistoryBytes) {
      throw ArgumentError('Prayer history exceeds the supported size');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(legacyCompletedKey, snapshot.legacyCompleted);
    await prefs.setString(recordsKey, encoded);
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

void _rejectDuplicateRecords(List<PrayerRecord> records) {
  final seen = <String>{};
  for (final record in records) {
    final key = '${record.prayer}|'
        '${record.completedAt.toUtc().microsecondsSinceEpoch}';
    if (!seen.add(key)) {
      throw const FormatException('Duplicate Qadaa prayer record');
    }
  }
}

/// Versioned, portable backup format. Import rejects invalid payloads before
/// any persisted value is changed. The limits also protect the import path
/// from unexpectedly large clipboard contents.
class QadaaBackup {
  const QadaaBackup({
    required this.years,
    required this.dailyTarget,
    required this.snapshot,
  });

  static const maxSourceLength = 1024 * 1024;
  static const maxRecords = 10000;

  final int years;
  final int dailyTarget;
  final QadaaPrayerStoreSnapshot snapshot;

  String encode() {
    if (snapshot.records.length > maxRecords) {
      throw ArgumentError('Backup contains too many prayer records');
    }
    _rejectDuplicateRecords(snapshot.records);
    final result = jsonEncode({
      'format': 'qadaa-backup',
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'years': years,
      'dailyTarget': dailyTarget,
      'legacyCompleted': snapshot.legacyCompleted,
      'records': snapshot.records.map((record) => record.toJson()).toList(),
    });
    if (result.length > maxSourceLength) {
      throw ArgumentError('Backup exceeds the supported size');
    }
    return result;
  }

  factory QadaaBackup.decode(String source) {
    if (source.length > maxSourceLength) {
      throw const FormatException('Qadaa backup exceeds the supported size');
    }
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != 'qadaa-backup' ||
        decoded['version'] != 1) {
      throw const FormatException('Unsupported Qadaa backup');
    }
    final years = decoded['years'];
    final dailyTarget = decoded['dailyTarget'];
    final legacy = decoded['legacyCompleted'];
    final rawRecords = decoded['records'];
    if (years is! int || years < 0 || years > 80 ||
        dailyTarget is! int || dailyTarget < 1 || dailyTarget > 20 ||
        legacy is! int || legacy < 0 || legacy > 1000000000 ||
        rawRecords is! List || rawRecords.length > maxRecords) {
      throw const FormatException('Invalid Qadaa backup values');
    }
    final records = rawRecords.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid Qadaa backup record');
      }
      return PrayerRecord.fromJson(item);
    }).toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    _rejectDuplicateRecords(records);
    return QadaaBackup(
      years: years,
      dailyTarget: dailyTarget,
      snapshot: QadaaPrayerStoreSnapshot(
        legacyCompleted: legacy,
        records: records,
      ),
    );
  }
}
