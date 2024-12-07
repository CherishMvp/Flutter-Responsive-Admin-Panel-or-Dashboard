import 'package:com.cherish.admin/controllers/menu_app_controller.dart';
import 'package:com.cherish.admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Header extends StatelessWidget {
  /// 根据不同设备处理drawer的开关
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          GestureDetector(
            //带点击事件的组件（没有水波纹debuff）
            onTap: () => context.read<MenuAppController>().controlMenu(),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, defaultPadding * 0.75,
                  defaultPadding * 0.75, defaultPadding * 0.75),
              margin: EdgeInsets.only(right: defaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset(
                "assets/icons/menu_dashboard.svg",
                width: 28,
                height: 28,
              ),
            ),
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        // Expanded(child: SearchField()),
        Expanded(child: mySearchBar()),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Angelina Jolie"),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none, //一定去除border
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          //带点击事件的组件（没有水波纹debuff）
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}

Padding mySearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: TextField(
      decoration: InputDecoration(
        filled: true,
        prefixIcon: const Icon(Icons.search),
        // fillColor: Colors.white,
        fillColor: secondaryColor,
        border: InputBorder.none,
        hintText: "Search",
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    ),
  );
}
