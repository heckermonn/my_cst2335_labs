import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// import entity and dao
import 'shopping_item.dart';

// The generated code will be in this file
part 'database.g.dart';

//dao object
@dao
abstract class ShoppingItemDao {
  @Query('SELECT * FROM ShoppingItem')
  Future<List<ShoppingItem>> findAllItems();

  @insert
  Future<void> insertItem(ShoppingItem item);

  @delete
  Future<void> deleteItem(ShoppingItem item);
}

@Database(version: 1, entities: [ShoppingItem])
abstract class AppDatabase extends FloorDatabase {
  ShoppingItemDao get shoppingItemDao;
}