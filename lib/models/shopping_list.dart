import 'package:uuid/uuid.dart';

class ShoppingList {
  final String id; // 唯一标识符
  final String name; // 购物清单名称（例如：本周购物清单）

  final List<ShoppingItem> items; // 购物项列表
  /// 创建时间
  final DateTime createdAt;
  final DateTime? updatedAt;
  ShoppingList({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.name,
    required this.items,
  })  : id = id ?? Uuid().v1(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = DateTime.now();

  // 从JSON构建购物清单
  factory ShoppingList.fromJson(
      Map<String, dynamic> json, List<ShoppingItem> shoppingItemsList) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      items: shoppingItemsList,
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
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class ShoppingItem {
  final String id; // 唯一标识符
  final String name; // 食材名称
  final int quantity; // 购买数量
  /// 创建时间
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShoppingItem(
      {String? id,
      required this.name,
      required this.quantity,
      DateTime? createdAt,
      DateTime? updatedAt})
      : id = id ?? Uuid().v1(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = DateTime.now();

  // 从JSON构建购物项
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
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
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
