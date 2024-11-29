import 'dart:developer';
import 'dart:io';

import 'package:com.cherish.admin/constants.dart';
import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/controllers/menu_app_controller.dart';
import 'package:com.cherish.admin/screens/main/main_screen.dart';
import 'package:com.cherish.admin/test/food/category_food_detail.dart';
import 'package:com.cherish.admin/test/food/expire_notification.dart';
import 'package:com.cherish.admin/test/food/food_page.dart';
import 'package:com.cherish.admin/test/fridge/category_page.dart';
import 'package:com.cherish.admin/test/fridge/fridge_page.dart';
import 'package:com.cherish.admin/test/index/test_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      minimumSize: Size(390, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  // 初始化通知帮助类
  NotificationHelper notificationHelper = NotificationHelper();
  await notificationHelper.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        // 如果你有其他需要管理的 Provider，可以继续添加
        ChangeNotifierProvider(
          create: (context) => FridgeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      routerConfig: _router, // 配置 GoRouter
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/', // 启动时默认加载的页面
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MainScreen();
      },
      routes: [
        GoRoute(
          path: '/test_page',
          builder: (context, state) {
            return const TestPage();
          },
        ),
        GoRoute(
          path: '/fridge_page',
          builder: (context, state) {
            return const FridgeTestPage();
          },
        ),
        GoRoute(
          path: '/category_page',
          builder: (context, state) {
            return const CategoryPage();
          },
        ),
        // ExpireNotification
        GoRoute(
          path: '/notification_page',
          builder: (context, state) {
            return const ExpireNotification();
          },
        ),
        GoRoute(
            path: '/food_page',
            builder: (context, state) {
              // 传入fid
              final fid = state.extra as String;
              return FoodPage(fridge_id: fid);
            }),
        GoRoute(
            path: '/category_detail/:category_id',
            builder: (context, state) {
              // 传入fid
              final fid = state.pathParameters['category_id'] ?? '1';
              log("fid: $fid");
              return CategoryPageDetail(category_id: fid);
            }),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    );
  },
);
