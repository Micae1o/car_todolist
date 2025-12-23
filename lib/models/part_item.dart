import 'package:hive/hive.dart';

part 'part_item.g.dart';

@HiveType(typeId: 0)
enum PartCategory {
  @HiveField(0)
  engine,
  @HiveField(1)
  transmission,
  @HiveField(2)
  suspension,
  @HiveField(3)
  brakes,
  @HiveField(4)
  electrics,
  @HiveField(5)
  body,
  @HiveField(6)
  fluids,
  @HiveField(7)
  other,
}

@HiveType(typeId: 1)
class PartItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  PartCategory category;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  bool purchased;

  @HiveField(4)
  String? notes;

  PartItem({
    required this.name,
    required this.category,
    this.quantity = 1,
    this.purchased = false,
    this.notes,
  });
}
