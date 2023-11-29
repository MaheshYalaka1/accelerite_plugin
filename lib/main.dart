import 'package:accelerite_plugin/products.dart';
import 'package:accelerite_plugin/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Place",
      //theme: Theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DashBoard", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue, // Set background color to white
        ),
        body: const MyGridView(),
      ),
    );
  }
}

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: [
        buildContainer(context, 'Http Req/Res', Colors.blue, MyHomePage()),
        buildContainer(
            context, 'Store Data', Colors.green, const PlacesScreen()),
        buildContainer(context, 'Push Notifications', Colors.red, null),
        buildContainer(
            context, 'Service 4', const Color.fromARGB(255, 111, 8, 246), null),
        buildContainer(context, 'Service 5',
            const Color.fromARGB(255, 196, 162, 240), null),
        buildContainer(
            context, 'Service 6', const Color.fromARGB(255, 246, 8, 234), null),
      ],
    );
  }

  Widget buildContainer(
      BuildContext context, String text, Color color, Widget? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
