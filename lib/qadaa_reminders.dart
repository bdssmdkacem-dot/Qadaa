import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// A validated local wall-clock time. The persisted representation is stable
/// across locale changes and device time-zone changes.
class ReminderTime {
  const ReminderTime({required this.hour, required this.minute});

  final int hour;
  final int minute;

  bool get isValid => hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;

  String get storageValue =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  static ReminderTime? tryParse(String? value) {
    if (value == null || !RegExp(r'^([01]\\d|2[0-3]):[0-5]\\d$').hasMatch(value)) {
      return null;
    }
    final parts = value.split(':');
    return ReminderTime(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  tz.TZDateTime nextOccurrence(tz.Location location, DateTime now) {
    if (!isValid) throw ArgumentError.value(this, 'time', 'Invalid reminder time');
    final localNow = tz.TZDateTime.from(now, location);
    var candidate = tz.TZDateTime(
      location,
      localNow.year,
      localNow.month,
      localNow.day,
      hour,
      minute,
    );
    if (!candidate.isAfter(localNow)) {
      candidate = tz.TZDateTime(
        location,
        localNow.year,
        localNow.month,
        localNow.day + 1,
        hour,
        minute,
      );
    }
    return candidate;
  }
}

/// Android local reminder adapter. It deliberately requests notification
/// permission only from [enableDailyReminder], which is called by a user
/// gesture, never during app startup.
class QadaaReminderService {
  QadaaReminderService._();

  static final QadaaReminderService instance = QadaaReminderService._();
  static const int dailyReminderId = 4101;
  static const String channelId = 'qadaa_daily_reminder';
  static const String channelName = 'Qadaa reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  Future<void>? _initializing;

  Future<void> initialize() {
    return _initializing ??= _initialize();
  }

  Future<void> _initialize() async {
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('qadaa_notification'),
      ),
    );
  }

  Future<bool> enableDailyReminder({
    required ReminderTime time,
    required String title,
    required String body,
    DateTime? now,
  }) async {
    if (!time.isValid) throw ArgumentError.value(time, 'time');
    await initialize();

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;

    final granted = await android.requestNotificationsPermission() ?? false;
    if (!granted) {
      await _plugin.cancel(id: dailyReminderId);
      return false;
    }

    final zoneInfo = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(zoneInfo.identifier);
    tz.setLocalLocation(location);
    final next = time.nextOccurrence(location, now ?? DateTime.now());

    await _plugin.cancel(id: dailyReminderId);
    await _plugin.zonedSchedule(
      id: dailyReminderId,
      title: title,
      body: body,
      scheduledDate: next,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'A gentle reminder to continue your Qadaa plan',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'qadaa_notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    return true;
  }

  Future<void> disableDailyReminder() async {
    await initialize();
    await _plugin.cancel(id: dailyReminderId);
  }

  /// Rebuilds the recurring alarm after app resume, including after a device
  /// time-zone change. The boot receiver in AndroidManifest handles reboot.
  Future<void> refreshDailyReminder({
    required bool enabled,
    required String storedTime,
    required String title,
    required String body,
  }) async {
    if (!enabled) return;
    final time = ReminderTime.tryParse(storedTime);
    if (time == null) {
      await disableDailyReminder();
      return;
    }
    await initialize();
    final zoneInfo = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(zoneInfo.identifier);
    tz.setLocalLocation(location);
    final next = time.nextOccurrence(location, DateTime.now());
    await _plugin.cancel(id: dailyReminderId);
    await _plugin.zonedSchedule(
      id: dailyReminderId,
      title: title,
      body: body,
      scheduledDate: next,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'A gentle reminder to continue your Qadaa plan',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'qadaa_notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
