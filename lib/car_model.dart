import 'package:hive/hive.dart';

part 'car_model.g.dart';

@HiveType(typeId: 1)
class Car extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final int id;

  Car(this.name, this.imageUrl, this.id);
}
