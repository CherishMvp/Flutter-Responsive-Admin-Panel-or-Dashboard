import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/models/fridge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DbTestPage extends StatefulWidget {
  const DbTestPage({super.key});

  @override
  State<DbTestPage> createState() => _DbTestPageState();
}

class _DbTestPageState extends State<DbTestPage> {
  @override
  void initState() {
    super.initState();
    // 初始加载冰箱数据.确保异步操作不会影响 UI 渲染。
    Future.microtask(() {
      // Provider.of<FridgeProvider>(context, listen: false).loadFridges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('fridge admin')),
      body: Consumer<FridgeProvider>(
        builder: (context, fridgeProvider, child) {
          // TODO 所有数据应该都会在main中最开始加载.不过在这里加载也可以
          // if (fridgeProvider.fridges.isEmpty) {
          //   return const Center(child: Text('No fridges found.'));
          // }

          return ListView.builder(
            itemCount: fridgeProvider.fridges.length,
            itemBuilder: (context, index) {
              final fridge = fridgeProvider.fridges[index];
              return ListTile(
                title: Text(fridge.name),
                subtitle: Text('冰箱ID: ${fridge.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // 更新冰箱名称
                        String newName = '';
                        await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('编辑冰箱名称'),
                              content: TextField(
                                decoration: const InputDecoration(
                                  labelText: '新名称',
                                ),
                                onChanged: (value) {
                                  newName = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(newName);
                                  },
                                  child: const Text('保存'),
                                ),
                              ],
                            );
                          },
                        );
                        if (newName.isNotEmpty) {
                          final updatedFridge = fridge.copyWith(name: newName);
                          await fridgeProvider.updateFridge(updatedFridge);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // 删除冰箱
                        await fridgeProvider.deleteFridge(fridge.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 添加新冰箱
          final fridge = Fridge(
            name: '我是默认新冰箱',
            foodItems: [],
            // isDefault: true,
            createdAt: DateTime.now(),
          );
          int result = await Provider.of<FridgeProvider>(context, listen: false)
              .addFridge(fridge);
          if (result == 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('添加失败'),
            ));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
