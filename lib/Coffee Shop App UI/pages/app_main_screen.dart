import 'package:com.cherish.admin/constants.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/icon_model.dart';

class CoffeeAppMainScreen extends StatefulWidget {
  const CoffeeAppMainScreen({super.key});

  @override
  State<CoffeeAppMainScreen> createState() => _CoffeeAppMainScreenState();
}

class _CoffeeAppMainScreenState extends State<CoffeeAppMainScreen> {
  int indexMenu = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menu[indexMenu]['destination'] as Widget,
      // backgroundColor: xbackgroundColor,
      backgroundColor: secondaryColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
            children: List.generate(menu.length, (index) {
          Map items = menu[index];
          bool isActive = indexMenu == index;
          return Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  indexMenu = index;
                });
              },
              child: SizedBox(
                height: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      items['icon'],
                      color: isActive ? xprimaryColor : xsecondaryColor,
                      size: 25,
                    ),
                    if (isActive) const SizedBox(height: 7),
                    if (isActive)
                      Container(
                        height: 5,
                        width: 15,
                        decoration: BoxDecoration(
                          color: xprimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        })),
      ),
    );
  }
}
