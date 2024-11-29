// 参考链接：https://blog.csdn.net/weixin_41897680/article/details/131947231
import 'dart:convert';
import 'dart:developer';

import 'package:com.cherish.admin/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// 后台通知点击
@pragma('vm:entry-point')
void _onReceiveBackgroundNotification(NotificationResponse details) {
  log("后台通知点击");
  log("后台通知点击${details.id}:${details.input}:${details.payload}");
  if (details.payload != null) {
    log("后台通知点击${details.payload}");
    // 跳转到指定页面
    approuter.push('/notification_receive', extra: details.payload);
  }
  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //   content: Text('添加失败'),
  // ));
  return null;
}

/// 前台通知点击
@pragma('vm:entry-point')
void _onDidReceiveNotification(NotificationResponse details) {
  log("前台通知点击");
  log("前台通知点击${details.id}:${details.input}:${details.payload}");
  if (details.payload != null) {
    log("前台通知点击${details.payload}");
    // 跳转到指定页面
    approuter.push('/notification_receive', extra: details.payload);
  }
  return null;
}

class NotificationChannels {
  static const String oneTimeChannelId = 'one_time_channel';
  static const String oneTimeChannelName = '一次性通知';
  static const String oneTimeChannelDescription = '这是一个一次性通知';

  static const String scheduledChannelId = 'scheduled_channel';
  static const String scheduledChannelName = '定时通知';
  static const String scheduledChannelDescription = '这是一个定时通知';

  static const String periodicChannelId = 'periodic_channel';
  static const String periodicChannelName = '周期通知';
  static const String periodicChannelDescription = '这是一个周期通知';

  static AndroidNotificationDetails get oneTimeDetails {
    return AndroidNotificationDetails(
      oneTimeChannelId,
      oneTimeChannelName,
      channelDescription: oneTimeChannelDescription,
    );
  }

  static AndroidNotificationDetails get scheduledDetails {
    return AndroidNotificationDetails(
      scheduledChannelId,
      scheduledChannelName,
      channelDescription: scheduledChannelDescription,
    );
  }

  static AndroidNotificationDetails get periodicDetails {
    return AndroidNotificationDetails(
      periodicChannelId,
      periodicChannelName,
      channelDescription: periodicChannelDescription,
    );
  }
}

class NotificationHelper {
  // 使用单例模式进行初始化
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  // FlutterLocalNotificationsPlugin是一个用于处理本地通知的插件，它提供了在Flutter应用程序中发送和接收本地通知的功能。
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 初始化函数
  Future<void> initialize() async {
    //  初始化tz
    tz.initializeTimeZones();
    // AndroidInitializationSettings是一个用于设置Android上的本地通知初始化的类
    // 使用了app_icon作为参数，这意味着在Android上，应用程序的图标将被用作本地通知的图标。
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 15.1是DarwinInitializationSettings，旧版本好像是IOSInitializationSettings（有些例子中就是这个）
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // 初始化
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            _onReceiveBackgroundNotification,
        onDidReceiveNotificationResponse: _onDidReceiveNotification);
    // 通过点击通知启动时
    _notificationsPlugin.getNotificationAppLaunchDetails().then((value) => {
          log("getNotificationAppLaunchDetails:$value"),
          if (value!.didNotificationLaunchApp)
            {
              // 跳转到指定页面
              approuter.push('/notification_receive',
                  extra: value.notificationResponse?.payload)
            }
        });
  }

  /// 权限申请
  Future<void> requestNotificationPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      final status1 = await Permission.scheduleExactAlarm.request();
      log("requestNotificationPermissions ：通知权限status1 $status1");
      if (status.isGranted) {
        log("requestNotificationPermissions ：通知权限已授予");
        print('通知权限已授予');
      } else {
        log("requestNotificationPermissions ：通知权限被拒绝");
        print('通知权限被拒绝');
      }
    } else {
      log("requestNotificationPermissions ：通知权限已授予");
      print('通知权限已授予');
    }
    if (!await Permission.scheduleExactAlarm.isGranted ||
        !await Permission.notification.isGranted) {
      openAppSettings();
    }
  }

  ///  一次性普通通知
  Future<void> showNotification(
      {int id = 1,
      String payload = "点击通知后的附带信息",
      required String title,
      required String body}) async {
    // 安卓的通知
    // 'your channel id'：用于指定通知通道的ID。
    // 'your channel name'：用于指定通知通道的名称。
    // 'your channel description'：用于指定通知通道的描述。
    // Importance.max：用于指定通知的重要性，设置为最高级别。
    // Priority.high：用于指定通知的优先级，设置为高优先级。
    // 'ticker'：用于指定通知的提示文本，即通知出现在通知中心的文本内容。
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(NotificationChannels.oneTimeChannelId,
            NotificationChannels.oneTimeChannelName,
            channelDescription: NotificationChannels.oneTimeChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            // icon: "@mipmap/ic_launcher", //一定要这个 否则报错
            ticker: 'ticker');

    // ios的通知
    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
    );
    // 创建跨平台通知
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // 发起一个通知.payload是通知的附加信息，比如点击通知后打开的页面
    await _notificationsPlugin.show(
      id,
      title,
      body,
      payload: payload,
      platformChannelSpecifics,
    );
  }

  ///  周期性通知
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(NotificationChannels.periodicChannelId,
            NotificationChannels.periodicChannelName,
            channelDescription: NotificationChannels.periodicChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            ticker: 'ticker');

    // ios的通知
    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
    );
    // 创建跨平台通知
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    // 发起通知
    await _notificationsPlugin.periodicallyShow(
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle, //安卓设备需要额外配置
        id,
        title,
        body,
        RepeatInterval.everyMinute,
        platformChannelSpecifics);
  }

  /// 定时通知
  Future<void> zonedScheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledDateTime}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(NotificationChannels.scheduledChannelId,
            NotificationChannels.scheduledChannelName,
            channelDescription:
                NotificationChannels.scheduledChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    // ios的通知
    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
    );
    // 创建跨平台通知
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    // 发起通知
    await _notificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      id, title, body,
      tz.TZDateTime.from(scheduledDateTime, tz.local), // 使用本地时区的时间
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime, // 设置通知的触发时间是觉得时间
    );
  }

  /// 取消通知
  Future<void> cancelNotification(int id) async {
    if (id == 0) {
      cancelAllNotification();
      return;
    }
    await _notificationsPlugin.cancel(id);
  }

  /// 取消所有通知
  Future<void> cancelAllNotification() async {
    await _notificationsPlugin.cancelAll();
  }
}
