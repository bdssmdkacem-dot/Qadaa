import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:qadaa/qadaa_reminders.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);

  group('ReminderTime', () {
    test('parses and normalizes a valid 24-hour time', () {
      final time = ReminderTime.tryParse('08:05');
      expect(time, isNotNull);
      expect(time!.hour, 8);
      expect(time.minute, 5);
      expect(time.storageValue, '08:05');
    });

    test('rejects malformed and out-of-range values', () {
      for (final value in [null, '', '8:05', '24:00', '12:60', '-1:00', '12:3x']) {
        expect(ReminderTime.tryParse(value), isNull, reason: '$value');
      }
    });

    test('chooses the next same-day occurrence in the selected IANA zone', () {
      final riyadh = tz.getLocation('Asia/Riyadh');
      const time = ReminderTime(hour: 8, minute: 30);
      final next = time.nextOccurrence(riyadh, DateTime.utc(2026, 11, 25, 4));
      expect(next.year, 2026);
      expect(next.month, 11);
      expect(next.day, 25);
      expect(next.hour, 8);
      expect(next.minute, 30);
      expect(next.timeZoneOffset, const Duration(hours: 3));
    });

    test('moves to tomorrow when the selected local time has passed', () {
      final riyadh = tz.getLocation('Asia/Riyadh');
      final time = ReminderTime(hour: 8, minute: 30);
      final next = time.nextOccurrence(riyadh, DateTime.utc(2026, 11, 25, 6));
      expect(next.year, 2026);
      expect(next.month, 11);
      expect(next.day, 26);
      expect(next.hour, 8);
      expect(next.minute, 30);
    });

    test('treats the exact current minute as already passed', () {
      final utc = tz.getLocation('Etc/UTC');
      final time = ReminderTime(hour: 8, minute: 30);
      final next = time.nextOccurrence(utc, DateTime.utc(2026, 11, 25, 8, 30));
      expect(next.day, 26);
      expect(next.hour, 8);
      expect(next.minute, 30);
    });

    test('rejects invalid constructor values before scheduling', () {
      final utc = tz.getLocation('Etc/UTC');
      expect(
        () => const ReminderTime(hour: 24, minute: 0)
            .nextOccurrence(utc, DateTime.utc(2026, 11, 25)),
        throwsArgumentError,
      );
    });
  });
}
