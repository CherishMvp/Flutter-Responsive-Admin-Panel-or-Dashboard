import 'package:com.cherish.admin/constants.dart';
import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.fridge_id});
  final String fridge_id;
  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  void initState() {
    super.initState();
    // 初始加载食材数据.确保异步操作不会影响 UI 渲染。
    Future.microtask(() {
      // Provider.of<FridgeProvider>(context, listen: false).loadFridges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('food admin${widget.fridge_id}')),
      body: Consumer<FridgeProvider>(
        builder: (context, fridgeProvider, child) {
          // TODO 所有数据应该都会在main中最开始加载.不过在这里加载也可以
          // if (fridgeProvider.fridges.isEmpty) {
          //   return const Center(child: Text('No fridges found.'));
          // }

          return ListView.builder(
            itemCount: fridgeProvider.getFridgeFoods(widget.fridge_id).length,
            itemBuilder: (context, index) {
              final food =
                  fridgeProvider.getFridgeFoods(widget.fridge_id)[index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text('食材ID: ${food.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // 更新食材名称
                        String newName = '';
                        await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('编辑食材名称'),
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
                          final updatedFridge = food.copyWith(name: newName);
                          await fridgeProvider.updateFoodItem(updatedFridge);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // 删除食材
                        int result =
                            await fridgeProvider.deleteFoodItem(food.id);
                        if (result == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('默认冰箱不能删除'),
                          ));
                        }
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
          // 添加新食材
          final fridge = FoodItem(
            name: '${widget.fridge_id.substring(0, 4)}_${RandomText.word()}',
            category: 'Fruit',
            quantity: 1,
            fridgeId: widget.fridge_id, //注意带上冰箱ID，从上一级传来。默认为1
            purchaseDate: DateTime.now(),
            expiryDate: DateTime.now().add(const Duration(days: 30)),
            storageLocation: '冰箱上层',
            isExpired: false,
          );
          int result = await Provider.of<FridgeProvider>(context, listen: false)
              .addFoodItem(fridge);
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
