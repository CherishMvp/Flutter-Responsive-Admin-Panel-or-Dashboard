import 'dart:math';

import 'package:com.cherish.admin/utils/local_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ExpireNotification extends StatefulWidget {
  const ExpireNotification({super.key});

  @override
  State<ExpireNotification> createState() => _ExpireNotificationState();
}

class _ExpireNotificationState extends State<ExpireNotification> {
  final _notificationHelper = NotificationHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expire Notification'),
      ),
      body: ListView(children: [
        ListTile(
          title: const Text("一次性通知"),
          onTap: () => _sendOnceNotification(),
        ),
        ListTile(
          title: const Text("周期性通知"),
          onTap: () => _sendScheduleNotification(),
        ),
        // zonedScheduleNotification
        ListTile(
          title: const Text("定时通知"),
          onTap: () => _sendZonedScheduleNotification(),
        ),
        ListTile(
          title: const Text("取消通知"),
          onTap: () => _cancelNotification(),
        ),
      ]),
    );
  }

  _sendOnceNotification() async {
    if (await Permission.notification.request().isGranted) {
      debugPrint("isGranted true");
      //点击发送通知
      Map params = {};
      params['type'] = 200;
      params['id'] = "10086";
      params['content'] = "content";
      int id = Random().nextInt(10000);
      _notificationHelper.showNotification(
        id: id,
        title: 'Hello' + id.toString(),
        body: 'World' + id.toString(),
      );
    } else {
      debugPrint("isGranted false");
      //打开应用设置
      final flag = await showAdaptiveDialog(
          context: context,
          builder: (builder) => const Dialog(
                child: Text("请打开通知权限"),
              ));
      if (flag != null && flag) {
        openAppSettings();
      }
    }
  }

  // 周期通知
  _sendScheduleNotification() async {
    if (await Permission.notification.request().isGranted) {
      debugPrint("isGranted true");
      //点击发送通知
      Map params = {};
      params['type'] = 200;
      params['id'] = "10086";
      params['content'] = "content";
      _notificationHelper.scheduleNotification(
          id: 1, title: "scheduleExactAlarm", body: "scheduleExactAlarm");
    } else {
      debugPrint("isGranted false");
      //打开应用设置
      final flag = await showAdaptiveDialog(
          context: context,
          builder: (builder) => const Dialog(
                child: Text("请打开通知权限"),
              ));
      if (flag != null && flag) {
        openAppSettings();
      }
    }
  }

  _sendZonedScheduleNotification() async {
    if (await Permission.notification.request().isGranted) {
      debugPrint("isGranted true");
      //点击发送通知
      Map params = {};
      params['type'] = 200;
      params['id'] = "10086";
      params['content'] = "content";
      _notificationHelper.zonedScheduleNotification(
          id: 1,
          title: "定时通知",
          body: "定时通知",
          scheduledDateTime: DateTime.now().add(const Duration(seconds: 10)));
    } else {
      debugPrint("isGranted false");
      //打开应用设置
      final flag = await showAdaptiveDialog(
          context: context,
          builder: (builder) => const Dialog(
                child: Text("请打开通知权限"),
              ));
      if (flag != null && flag) {
        openAppSettings();
      }
    }
  }

  /// 取消通知 0为全部
  _cancelNotification({int id = 0}) {
    _notificationHelper.cancelNotification(id);
  }
}
