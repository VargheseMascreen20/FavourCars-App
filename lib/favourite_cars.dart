import 'package:flutter/material.dart';
import 'package:flutter_sample/car_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteCarsPage extends StatelessWidget {
  final favoriteCarsBox = Hive.box<Car>('favorite_car');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Favorite Cars'),
        actions: [
          IconButton(
              onPressed: () {
                deleteAllValues(favoriteCarsBox);
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: FavoriteCarsList(),
    );
  }

  void deleteAllValues(Box box) {
    for (var key in box.keys) {
      box.delete(key);
    }
  }
}

class FavoriteCarsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteCarsBox = Hive.box<Car>('favorite_car');

    return ValueListenableBuilder(
      valueListenable: favoriteCarsBox.listenable(),
      builder: (context, Box<Car> box, _) {
        if (favoriteCarsBox.isEmpty) {
          return Center(
            child: Text(
              'No favorite cars yet. 😊',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemCount: favoriteCarsBox.length,
            itemBuilder: (context, listIndex) {
              final car = favoriteCarsBox.getAt(listIndex);
              return ListTile(
                leading: Container(
                  height: 50,
                  width: 80,
                  child: Image.network(
                    fit: BoxFit.fill,
                    car!.imageUrl,
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Text(car.name),
              );
            },
          ),
        );
      },
    );
  }
}
