import 'dart:developer';

import 'package:com.cherish.admin/Coffee%20Shop%20App%20UI/pages/splash_screen.dart';
import 'package:com.cherish.admin/test/index/notification_receive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:com.cherish.admin/screens/main/main_screen.dart';
import 'package:com.cherish.admin/test/food/category_food_detail.dart';
import 'package:com.cherish.admin/test/food/expire_notification.dart';
import 'package:com.cherish.admin/test/food/food_page.dart';
import 'package:com.cherish.admin/test/fridge/category_page.dart';
import 'package:com.cherish.admin/test/fridge/fridge_page.dart';
import 'package:com.cherish.admin/test/index/test_page.dart';
import 'package:go_router/go_router.dart';

GoRouter get approuter => AppRouter.router;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // 启动时默认加载的页面
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // return const MainScreen();
          return const SplashScreen(); //coffee page
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
          // NotificationReceive
          GoRoute(
              path: '/notification_receive',
              builder: (context, state) {
                final String info = state.extra as String;
                return NotificationReceive(payload: info);
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
}
