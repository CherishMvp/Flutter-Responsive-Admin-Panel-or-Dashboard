import 'package:uuid/uuid.dart';

/// 食材基础信息
class FoodItem {
  /// 唯一标识符，方便管理
  final String id;

  /// 食材名称
  final String name;

  /// 食材类型（例如：蔬菜、水果、肉类、乳制品等） 分类从后端获取，不需要自己去匹配
  final String category;

  /// 食材数量
  final int quantity;

  /// 购买日期
  final DateTime purchaseDate;

  /// 过期日期
  final DateTime expiryDate;

  /// 存储位置（例如：冰箱上层、冰箱下层、冷冻区）
  final String storageLocation;

  /// 是否过期（可以根据当前时间和过期时间计算）
  final bool isExpired;

  /// 关联的冰箱ID
  String? fridgeId;

  FoodItem({
    String? id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.purchaseDate,
    required this.expiryDate,
    required this.storageLocation,
    this.isExpired = false,
    this.fridgeId,
  }) : id = id ?? Uuid().v1();

  //  copyWith
  FoodItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? storageLocation,
    bool? isExpired,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      storageLocation: storageLocation ?? this.storageLocation,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  // 检查是否过期
  bool checkIfExpired() {
    return DateTime.now().isAfter(expiryDate);
  }

  // 返回食材的剩余天数
  int daysUntilExpiry() {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  // 用于从JSON构建对象
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      storageLocation: json['storageLocation'],
      isExpired: json['isExpired'] == 1, // SQLite 中布尔值转换
    );
  }

  // 转换成JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'storageLocation': storageLocation,
      'isExpired': isExpired ? 1 : 0,
    };
  }
}

/// 食材类别
class FoodCategory {
  final String id;
  final String name;
  final String icon;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FoodCategory({
    required this.name,
    required this.icon,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? Uuid().v1(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = DateTime.now();

  ///copyWith 方法是为了方便创建一个新的 FoodCategory 对象，并且只更新指定的字段
  FoodCategory copyWith({
    String? id,
    String? name,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

List<FoodItem> foodItems = [
  FoodItem(
    id: '1',
    name: 'Apple',
    category: 'Fruit',
    quantity: 5,
    purchaseDate: DateTime.now(),
    expiryDate: DateTime.now().add(Duration(days: 30)),
    storageLocation: '冰箱上层',
    isExpired: false,
  ),
  FoodItem(
    id: '2',
    name: 'Banana',
    category: 'Fruit',
    quantity: 3,
    purchaseDate: DateTime.now(),
    expiryDate: DateTime.now().add(Duration(days: 15)),
    storageLocation: '冰箱下层',
    isExpired: false,
  ),
  FoodItem(
    id: '3',
    name: 'Orange',
    category: 'Fruit',
    quantity: 2,
    purchaseDate: DateTime.now(),
    expiryDate: DateTime.now().add(Duration(days: 10)),
    storageLocation: '冰箱下层',
    isExpired: false,
  ),
];

List<FoodCategory> foodCategories = [
  FoodCategory(name: 'Fruit', icon: 'assets/icons/fruit.png'),
  FoodCategory(name: 'Vegetable', icon: 'assets/icons/vegetable.png'),
  FoodCategory(name: 'Meat', icon: 'assets/icons/meat.png'),
  FoodCategory(name: 'Dairy', icon: 'assets/icons/dairy.png'),
  FoodCategory(name: 'Beverage', icon: 'assets/icons/beverage.png'),
  FoodCategory(name: 'Snack', icon: 'assets/icons/snack.png'),
  FoodCategory(name: 'Other', icon: 'assets/icons/other.png'),
];
