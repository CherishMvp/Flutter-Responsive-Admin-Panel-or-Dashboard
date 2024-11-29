import 'package:com.cherish.admin/screens/main/main_screen.dart';
import 'package:com.cherish.admin/test/food/expire_notification.dart';
import 'package:com.cherish.admin/test/fridge/category_page.dart';
import 'package:com.cherish.admin/test/fridge/fridge_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../pages/home_screen.dart';

final menubefore = [
  {
    'icon': Iconsax.home5,
    'destination': const CoffeeAppHomeScreen(),
  },
  {
    'icon': Iconsax.heart,
    'destination': const Center(child: Text('Favorite')),
  },
  {
    'icon': Iconsax.shopping_bag,
    'destination': const Center(child: Text('Shopping')),
  },
  {
    'icon': Iconsax.notification,
    'destination': const Center(child: Text('Notification')),
  },
];

final menu = [
  {
    'icon': Iconsax.home5,
    'destination': const MainScreen(),
  },
  {
    'icon': Iconsax.heart,
    'destination': const FridgeTestPage(),
  },
  {
    'icon': Iconsax.shopping_bag,
    'destination': const CategoryPage(),
  },
  {
    'icon': Iconsax.notification,
    'destination': const ExpireNotification(),
  },
];
