import 'package:com.cherish.zwt.fridge/controllers/fridge_controller.dart';
import 'package:com.cherish.zwt.fridge/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  /// 分类信息展示页面
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('category admin')),
      body: Consumer<FridgeProvider>(
        builder: (context, fridgeProvider, child) {
          // TODO 所有数据应该都会在main中最开始加载.不过在这里加载也可以
          // if (fridgeProvider.fridges.isEmpty) {
          //   return const Center(child: Text('No fridges found.'));
          // }

          return ListView.builder(
            itemCount: fridgeProvider.foodCategory.length,
            itemBuilder: (context, index) {
              final category = fridgeProvider.foodCategory[index];
              return ListTile(
                title: Text('${category.name + '  ' + category.icon}'),
                subtitle: Text('分类ID: ${category.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // 更新分类名称
                        String newName = '';
                        await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('编辑分类名称'),
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
                          final updatedFridge =
                              category.copyWith(name: newName);
                          await fridgeProvider
                              .updateFoodCategory(updatedFridge);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // 删除分类
                        int result = await fridgeProvider
                            .deleteFoodCategory(category.id);
                        if (result == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('分类删除失败，存在食材或为默认分类'),
                          ));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () async {
                        // 更新食材
                        context.push('/category_detail/${category.id}');
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
          // 添加新分类(食品可以不添加)
          final category = FoodCategory(
            name: '默认分类',
            icon: '😀',
          );
          int result = await Provider.of<FridgeProvider>(context, listen: false)
              .addFoodCategory(category);
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
