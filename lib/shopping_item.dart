import 'package:floor/floor.dart';

@entity
class ShoppingItem {
  @primaryKey
  final int id;
  String name;
  String quantity;

  // Static ID counter to ensure unique IDs for new items.
  static int ID = 1;

  ShoppingItem(this.id, this.name, this.quantity) {
    // ensure the static ID counter is higher than any existing ID.
    if (id >= ID) {
      ID = id + 1;
    }
  }
}