import 'package:uuid/uuid.dart';

import 'food_item.dart';

class Fridge {
  /// 唯一标识符
  final String id;

  /// 冰箱名称（如：家用冰箱，办公室冰箱等）
  final String name;

  /// 存储的食材列表
  List<FoodItem>? foodItems;

  /// 是否默认
  bool isDefault = false;

  /// 创建时间
  final DateTime createdAt;
  final DateTime? updatedAt;

  Fridge({
    String? id,
    List<FoodItem>? foodItems,
    required this.name,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? Uuid().v1(),
        createdAt = createdAt ?? DateTime.now(),
        isDefault = isDefault ?? false,
        foodItems = foodItems ?? [],
        updatedAt = DateTime.now();

  /// copyWith 方法是为了方便创建一个新的 Fridge 对象，并且只更新指定的字段
  Fridge copyWith({
    String? id,
    String? name,
    List<FoodItem>? foodItems,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Fridge(
      id: id ?? this.id,
      name: name ?? this.name,
      foodItems: foodItems ?? this.foodItems,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 返回所有已过期的食材
  List<FoodItem> getExpiredFoodItems() {
    if (foodItems == null) return [];
    return foodItems!.where((food) => food.checkIfExpired()).toList();
  }

  // 从JSON构建冰箱对象
  factory Fridge.fromJson(
      Map<String, dynamic> json, List<FoodItem> foodItemList) {
    return Fridge(
      id: json['id'],
      name: json['name'],
      foodItems: foodItemList,
      // 转换时间格式
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // 转换成JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault == true ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
