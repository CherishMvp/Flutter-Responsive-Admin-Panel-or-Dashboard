import 'package:com.cherish.admin/utils/local_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
// 申请通知权限
  Future<void> requestNotificationPermission() async {
    if (!kIsWeb) {
      await NotificationHelper().requestNotificationPermissions();
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("test"),
        ),
        body: ListView(children: [
          ListTile(
            title: const Text("冰箱页面"),
            onTap: () {
              context.push('/fridge_page');
            },
          ),
          ListTile(
            title: const Text("分类页面"),
            onTap: () {
              context.push('/category_page');
            },
          ),
          // 通知页面
          ListTile(
            title: const Text("通知页面"),
            onTap: () {
              context.push('/notification_page');
            },
          ),
        ]));
  }
}
