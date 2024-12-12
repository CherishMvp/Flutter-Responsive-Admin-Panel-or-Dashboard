import 'dart:developer';
import 'dart:io';

import 'package:com.cherish.admin/constants.dart';
import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/controllers/menu_app_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'controllers/locale_controller.dart';
import 'generated/l10n.dart';
import 'router/router.dart';
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
    LocaleController localeChangeNotifier = LocaleController();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // title: S.of(context).name,
      // 多语言配置
      locale: localeChangeNotifier.locale,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        if (localeChangeNotifier.locale == null) {
          localeChangeNotifier.init(
              supportedLocales.contains(locale!) ? locale : const Locale("en"));
        }
        return localeChangeNotifier.locale;
      },
      // supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      routerConfig: approuter, // 配置 GoRouter
    );
  }
}
