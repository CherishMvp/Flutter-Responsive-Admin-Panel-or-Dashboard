import 'package:com.cherish.admin/responsive.dart';
import 'package:com.cherish.admin/screens/dashboard/components/my_fields.dart';
import 'package:com.cherish.admin/screens/dashboard/components/my_fridges.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/recent_foods.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            // 主要面板内容
            // DESC 如果是宽屏幕设备：那就是row左右布局，左侧5/7 ，右侧2/7 中间加上一个defaultPadding.
            //      如果是移动设备：那就是只有左侧的5/7 变成了flex:1独占一行。然后子内容column依次布局。最终加上右侧的2/7在宽屏幕应该显示的内容拼接上
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // MyFiles(),
                      MyFridge(),
                      SizedBox(height: defaultPadding),
                      // RecentFiles(),
                      RecentFoods(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
