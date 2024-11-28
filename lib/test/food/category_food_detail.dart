import 'package:com.cherish.admin/constants.dart';
import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPageDetail extends StatefulWidget {
  /// 展示指定分类下的食材下的食材
  const CategoryPageDetail({super.key, required this.category_id});
  final String category_id;
  @override
  State<CategoryPageDetail> createState() => _CategoryPageDetailState();
}

class _CategoryPageDetailState extends State<CategoryPageDetail> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('category food detail ${widget.category_id}')),
      body: Consumer<FridgeProvider>(
        builder: (context, fridgeProvider, child) {
          // TODO 所有数据应该都会在main中最开始加载.不过在这里加载也可以
          // if (fridgeProvider.fridges.isEmpty) {
          //   return const Center(child: Text('No fridges found.'));
          // }

          return ListView.builder(
            itemCount:
                fridgeProvider.getFoodCategoryFoods(widget.category_id).length,
            itemBuilder: (context, index) {
              final category = fridgeProvider
                  .getFoodCategoryFoods(widget.category_id)[index];
              return ListTile(
                title: Text(category.name),
                subtitle: Text('分类下的食材ID: ${category.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // 更新分类下的食材名称
                        String newName = '';
                        await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('编辑分类下的食材名称'),
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
                          await fridgeProvider.updateFoodItem(updatedFridge);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // 删除分类下的食材
                        int result =
                            await fridgeProvider.deleteFoodItem(category.id);
                        if (result == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('删除失败 '),
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
          // 添加新分类下的食材
          final fridge = FoodItem(
            name: '${widget.category_id.substring(0, 4)}_${RandomText.word()}',
            category: context.read<FridgeProvider>().foodCategory.first.name,
            categoryId: widget.category_id,
            quantity: 1,
            // fridgeId: widget.category_id, //在这个分类页面，冰箱ID需要下拉筛选
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
