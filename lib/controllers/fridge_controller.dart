import 'dart:developer';

import 'package:com.cherish.admin/db/database_helper.dart';
import 'package:com.cherish.admin/models/food_item.dart';
import 'package:com.cherish.admin/models/fridge.dart';
import 'package:flutter/material.dart';

class FridgeProvider with ChangeNotifier {
  List<Fridge> _fridges = [];

  List<Fridge> get fridges => _fridges;

  // 当前冰箱的食材列表
  List<FoodItem> getFridgeFoods(String fridgeId) =>
      _fridges.firstWhere((fridge) => fridge.id == fridgeId).foodItems ?? [];

  FridgeProvider() {
    log("provider初始化");
    init();
  }

  // 初始化
  Future<void> init() async {
    log("init初始化");
    await loadFridges(); // 加载所有冰箱和食材数据
    print("FridgeProvider initialized");
  }

  // 加载所有冰箱和食材数据
  Future<void> loadFridges() async {
    log("provider加载冰箱和食材数据");
    _fridges = await DatabaseHelper.getFridges();
    notifyListeners();
  }

  // 保存冰箱和食材数据
  Future<int> addFridge(Fridge fridge) async {
    int result = await DatabaseHelper.saveFridge(fridge);
    await loadFridges(); // 更新列表
    return result;
  }

  // 删除冰箱及其食材
  Future<int> deleteFridge(String fridgeId) async {
    int result = await DatabaseHelper.deleteFridge(fridgeId);
    await loadFridges(); // 更新列表
    return result;
  }

  // 更新冰箱
  Future<void> updateFridge(Fridge updatedFridge) async {
    await DatabaseHelper.updateFridge(updatedFridge); // 保存到数据库
    int index = _fridges.indexWhere((fridge) => fridge.id == updatedFridge.id);
    if (index != -1) {
      _fridges[index] = updatedFridge; // 更新本地列表
      notifyListeners();
    }
  }

  // #region  食材
  // 添加食材
  Future<int> addFoodItem(FoodItem foodItem) async {
    int result = await DatabaseHelper.addFoodItem(foodItem);
    await loadFridges(); // 更新列表
    return result;
  }

  // 批量添加
  Future<int> addFoodItemBatch(List<FoodItem> foodItems) async {
    int result = await DatabaseHelper.addFoodItemBatch(foodItems);
    await loadFridges(); // 更新列表
    return result;
  }

  // 更新食材
  Future<int> updateFoodItem(FoodItem updatedFoodItem) async {
    int result = await DatabaseHelper.updateFoodItem(updatedFoodItem); // 保存到数据库
    await loadFridges(); // 更新列表
    return result;
  }

  // 删除食材
  Future<int> deleteFoodItem(String foodItemId) async {
    int result = await DatabaseHelper.deleteFoodItem(foodItemId);
    await loadFridges(); // 更新列表
    return result;
  }

  // #endregion
}
