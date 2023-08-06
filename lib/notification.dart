import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  static Future<void> initializenoti() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              ledColor: Colors.amber,
              groupAlertBehavior: GroupAlertBehavior.Summary,
              channelKey: 'basic_channel',
              channelName: 'True Shop',
              channelDescription: 'Notification for test',
              defaultColor: Colors.yellow,
              importance: NotificationImportance.Max,
              playSound: true,
              channelShowBadge: true,
              criticalAlerts: true)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Group 1')
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint('onActionReceivedMethod');
  }

  static Future<void> showNotification({
    required final String title,
    required final body,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final bool schedual = false,
    final int? interval,
  }) async {
    assert(!schedual || (schedual && interval != null));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'basic_channel',
          title: title,
          body: ' ${body.toString()}',
          actionType: actionType,
          notificationLayout: notificationLayout,
          color: Colors.red,
          backgroundColor: Colors.red,
        ),
        schedule: schedual
            ? NotificationInterval(
                interval: interval,
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true)
            : null);
  }
}
