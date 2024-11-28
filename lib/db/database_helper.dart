import 'dart:convert';
import 'dart:developer';

import 'package:com.cherish.admin/models/food_item.dart';
import 'package:com.cherish.admin/models/fridge.dart';
import 'package:com.cherish.admin/models/shopping_list.dart';
import 'package:com.cherish.admin/utils/local_cache.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final dbVersion = 3;
  // 获取数据库实例
  // 获取数据库实例
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    log("_database is null$_database");
    final dbPath = join(await getDatabasesPath(), 'fridge_database.db');
    // await deleteDatabase(dbPath);
    // return _database!;
    log("dbPath:$dbPath");
    log("exists:${await databaseExists(dbPath)}");
    // 创建路径文件

// 注意createdAt的转换
    _database = await openDatabase(
      dbPath,
      // 如果_database不存在

      onCreate: (db, version) async {
        await db.execute(
            ''' CREATE TABLE fridges( id TEXT PRIMARY KEY, name TEXT, isDefault INTEGER, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ) ''');
        await db.execute(
            ''' CREATE TABLE food_items( id TEXT PRIMARY KEY, fridge_id TEXT, name TEXT, category TEXT, quantity INTEGER, purchaseDate TEXT, expiryDate TEXT, storageLocation TEXT, isExpired INTEGER, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(fridge_id) REFERENCES fridges(id) ) ''');
        await db.execute(
            ''' CREATE TABLE shopping_lists( id TEXT PRIMARY KEY, name TEXT, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ) ''');
        await db.execute(
            ''' CREATE TABLE shopping_items( id TEXT PRIMARY KEY, shopping_list_id TEXT, name TEXT, category TEXT, quantity INTEGER, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(shopping_list_id) REFERENCES shopping_lists(id) ) ''');
      },
      onUpgrade: (db, oldVersion, newVersion) =>
          _handleDBUpgrade(db, oldVersion, newVersion),
      version: dbVersion,
    );
    log("xx_database is not null$_database");
    if (await databaseExists(dbPath) && _database != null) {
      //  创建数据库后的一些默认数据
      await initFridge();
      log("xx_database is not null$_database");
    }
    return _database!;
  }

  static _handleDBUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      print("数据库升级，准备更新数据");
    }
  }

// #region冰箱开始

// mock数据

// 初始化默认一个冰箱表
  static initFridge() async {
    final cache = CacheHelper();
    if (await cache.isDBInit()) return;

    final defaultFridge = Fridge(
      id: '1',
      name: '默认冰箱',
      foodItems: [],
      isDefault: true,
      createdAt: DateTime.now(),
    );
    int result = await saveFridge(defaultFridge);
    log("默认数据插入情况:$result");
    // 存储默认情况

    await cache.setDBInit(true);
  }

// 插入默认冰箱（如果没有）
  static Future<void> insertDefaultFridge() async {
    final db = await getDatabase();

    // 检查数据库中是否已存在默认冰箱
    final fridgeList = await db.query(
      'fridges',
      where: 'isDefault = ?',
      whereArgs: [1], // 1 表示默认冰箱
    );

    if (fridgeList.isEmpty) {
      final fridgeInfo =
          Fridge(name: 'Default Fridge', id: 'default_fridge', isDefault: true);
      // 插入默认冰箱
      // 插入默认冰箱
      await db.insert(
        'fridges',
        fridgeInfo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 插入一些默认食材（如果需要的话）
      final foodInfo = FoodItem(
        name: "Apple",
        category: "Fruit",
        quantity: 12,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(Duration(days: 30)),
        storageLocation: "冰箱上层",
        isExpired: false,
      );
      await db.insert(
        'food_items',
        foodInfo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// 插入冰箱数据
  static Future<int> saveFridge(Fridge fridge) async {
    final db = await getDatabase();
    log("fridge:${fridge.toJson()}");

    // 检查表中是否已有默认冰箱
    if (fridge.isDefault == true) {
      final defaultFridge = await db.query(
        'fridges',
        where: 'isDefault = ?',
        whereArgs: [1],
      );

      // 如果已存在默认冰箱，更新其信息
      if (defaultFridge.isNotEmpty) {
        return 0;
      }
    }
    log("还有我？");
    // 插入或更新冰箱数据，如果冰箱已存在则替换
    return await db.insert(
      'fridges',
      fridge.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// 删除冰箱及其关联的食材（注意是提醒食材也会全部被删除）
  static Future<int> deleteFridge(String fridgeId) async {
    final db = await getDatabase();
// 不能删除默认冰箱isdefault或者id为1的
    if (fridgeId == '1') {
      return 0;
    }
    // 删除冰箱数据
    return await db.delete(
      'fridges',
      where: 'id = ?',
      whereArgs: [fridgeId],
    );

    // 可选：如果使用了外键，删除冰箱时可以自动删除相关的食材数据
    // await db.delete(
    //   'food_items',
    //   where: 'fridge_id = ?',
    //   whereArgs: [fridgeId],
    // );
  }

// 修改冰箱数据
  static Future<void> updateFridge(Fridge fridge) async {
    final db = await getDatabase();
    log("更新冰箱:${fridge.toJson()}");
    // 更新冰箱数据
    await db.update(
      'fridges',
      fridge.toJson(),
      where: 'id = ?',
      whereArgs: [fridge.id], // 根据冰箱ID来更新特定的记录
    );
  }

  // 获取所有冰箱和食材数据
  static Future<List<Fridge>> getFridges() async {
    final db = await getDatabase();

    // 获取冰箱列表
    final fridgeList = await db.query('fridges');
    log("fridgeList:${jsonEncode(fridgeList)}");
    List<Fridge> fridges = [];
    for (var fridge in fridgeList) {
      final foodItems = await db.query(
        'food_items',
        where: 'fridge_id = ?',
        whereArgs: [fridge['id']],
      );

      // 转换为 FoodItem 列表
      List<FoodItem> foodItemsList =
          foodItems.map((item) => FoodItem.fromJson(item)).toList();

      // 将食材列表与冰箱数据结合
      fridges.add(Fridge.fromJson(fridge, foodItemsList));
    }

    return fridges;
  }

  // 获取默认冰箱和食材数据
  static Future<Fridge?> getDefaultFridge() async {
    final db = await getDatabase();

    // 获取默认冰箱
    final fridgeList = await db.query(
      'fridges',
      where: 'isDefault = ?',
      whereArgs: [1], // 1 表示默认冰箱
    );

    if (fridgeList.isEmpty) {
      return null; // 如果没有找到默认冰箱，返回 null
    }

    final fridge = fridgeList.first;

    // 获取默认冰箱的食材列表
    final foodItems = await db.query(
      'food_items',
      where: 'fridge_id = ?',
      whereArgs: [fridge['id']],
    );

    // 转换为 FoodItem 列表
    List<FoodItem> foodItemsList =
        foodItems.map((item) => FoodItem.fromJson(item)).toList();

    // 返回默认冰箱对象
    return Fridge.fromJson(fridge, foodItemsList);
  }

// #endregion

// #region食材

// 根据冰箱id获取全部食材信息，默认id为"1"
  static Future<List<FoodItem>> loadFoodsByFridgeId(String fridgeId) async {
    final db = await getDatabase();
    final foodItems = await db.query(
      'food_items',
      where: 'fridge_id = ?',
      whereArgs: [fridgeId],
    );
    return foodItems.map((item) => FoodItem.fromJson(item)).toList();
  }

  /// 保存食材数据（插入或更新食材信息）
  static Future<int> addFoodItemBatch(List<FoodItem> foodItems) async {
    final db = await getDatabase();

    try {
      await db.transaction((txn) async {
        for (var foodItem in foodItems) {
          // 插入或更新食材数据
          await txn.insert(
            'food_items',
            foodItem.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace, // 出现冲突则替换
          );
        }
      });

      return 1; // 全部成功
    } catch (e) {
      log('添加食材出错：$e');
      return 0; // 添加失败
    }
  }

// 添加食材
  static Future<int> addFoodItem(FoodItem foodItem) async {
    final db = await getDatabase();
    return await db.insert(
      'food_items',
      foodItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// 删除食材
  static Future<int> deleteFoodItem(String foodItemId) async {
    final db = await getDatabase();
    return await db.delete(
      'food_items',
      where: 'id = ?',
      whereArgs: [foodItemId],
    );
  }

// 修改食材
  static Future<int> updateFoodItem(FoodItem foodItem) async {
    final db = await getDatabase();
    return await db.update(
      'food_items',
      foodItem.toJson(),
      where: 'id = ?',
      whereArgs: [foodItem.id],
    );
  }

//#endregion

// #region 购物清单
  // 获取购物清单和购物项
  static Future<List<ShoppingList>> getShoppingLists() async {
    final db = await getDatabase();

    // 获取购物清单列表
    final shoppingListData = await db.query('shopping_lists');

    List<ShoppingList> shoppingLists = [];
    for (var shoppingList in shoppingListData) {
      final shoppingItemsData = await db.query(
        'shopping_items',
        where: 'shopping_list_id = ?',
        whereArgs: [shoppingList['id']],
      );

      // 转换为 ShoppingItem 列表
      List<ShoppingItem> shoppingItemsList =
          shoppingItemsData.map((item) => ShoppingItem.fromJson(item)).toList();

      shoppingLists.add(ShoppingList.fromJson(shoppingList, shoppingItemsList));
    }

    return shoppingLists;
  }

  // 保存购物清单和购物项
  static Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final db = await getDatabase();

    // 插入购物清单
    await db.insert(
      'shopping_lists',
      {
        'id': shoppingList.id,
        'name': shoppingList.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 插入购物项
    for (var shoppingItem in shoppingList.items) {
      await db.insert(
        'shopping_items',
        shoppingItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

//#endregion
}
