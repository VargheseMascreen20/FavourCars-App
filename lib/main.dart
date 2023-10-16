import 'package:flutter/material.dart';
import 'package:flutter_sample/car_model.dart';
import 'package:flutter_sample/favourite_cars.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const favoritesBox = 'favorite_car';

List<Car> cars = [
  Car(
    'Toyota Camry',
    'https://www.cnet.com/a/img/resize/7a2ce0469f989f2f3521190c8fcb2f62e59e9c78/hub/2021/08/20/709f33d7-b139-45ad-899f-2c4cfd7216e9/2021-toyota-camry-trd-1.jpg?auto=webp&precrop=3000,1565,x0,y435&width=768',
    1,
  ),
  Car(
    'Honda Civic',
    'https://www.team-bhp.com/forum/attachments/modifications-accessories/1172813d1691674535t-pics-tastefully-modified-cars-india-image2749697134.jpg',
    2,
  ),
  Car(
    'Honda City',
    'https://www.motortrend.com/uploads/sites/5/2021/03/2021-Honda-City-Sedan-3.jpg?interpolation=lanczos-none&fit=around%7C660:440',
    3,
  ),
];

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CarAdapter());

  await Hive.openBox<Car>(favoritesBox);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Cars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<Car> favoriteCarsBox;

  @override
  void initState() {
    super.initState();
    favoriteCarsBox = Hive.box(favoritesBox);
  }

  Widget getIcon(int index) {
    if (favoriteCarsBox.containsKey(index)) {
      return const Icon(Icons.favorite, color: Colors.red);
    }
    return const Icon(Icons.favorite_border);
  }

  void onFavoritePress(int index) {
    if (favoriteCarsBox.containsKey(index)) {
      favoriteCarsBox.delete(index);
      return;
    }
    final carToAdd = cars[index];
    favoriteCarsBox.put(index, carToAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Cars'),
        ),
        body: ValueListenableBuilder(
          valueListenable: favoriteCarsBox.listenable(),
          builder: (context, Box<Car> box, _) {
            return ListView.builder(
              key: const Key('car_list_view'), // Add a key
              itemCount: cars.length,
              itemBuilder: (context, listIndex) {
                final car = cars[listIndex];
                return ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: Container(
                    height: 50,
                    width: 80,
                    child: Image.network(
                      fit: BoxFit.fill,
                      car.imageUrl,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(car.name),
                  trailing: IconButton(
                    icon: getIcon(listIndex),
                    onPressed: () => onFavoritePress(listIndex),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteCarsPage(),
                ),
              );
            }));
  }
}
