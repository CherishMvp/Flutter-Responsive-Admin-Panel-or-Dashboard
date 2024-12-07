import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationReceive extends StatefulWidget {
  const NotificationReceive({super.key, required this.payload});
  final String? payload;

  @override
  State<NotificationReceive> createState() => _NotificationReceiveState();
}

class _NotificationReceiveState extends State<NotificationReceive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        child: Icon(Icons.arrow_back_ios_new),
                        onTap: () {
                          context.go('/');
                        }),
                    Text("通知",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    )
                  ],
                ),
                const Center(child: Text("通知接收页面")),
                Center(child: Text("通知内容:${widget.payload}")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
