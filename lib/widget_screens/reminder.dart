import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static cancelNotification() => notification.cancelAll();
  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android =
        AndroidInitializationSettings('@drawable/launch_background');
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await notification.initialize(settings,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future<void> showScheduledNotification({
    int id = 0,
    required String? title,
    required String? body,
    required String? payload,
    required Time scheduledDateTime,
  }) async =>
      notification.zonedSchedule(
        id,
        title,
        body,
        scheduledDaily(scheduledDateTime),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      
  tz.TZDateTime scheduledDaily(Time? time) {
     tz.TZDateTime now = tz.TZDateTime.now(tz.local).add(
      Duration(
        hours: time!.hour,
        minutes: time.minute,
        seconds: 0,
      ),
    );

    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(
            const Duration(days: 1),
          )
        : scheduledDate;
  }
}
