import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> allTimeGreatGiftsList = [];
  List<Map<String, dynamic>> allCategoriesList = [];
  List<Map<String, dynamic>> homePageProducts1 = [];
  List<Map<String, dynamic>> homePageProducts = [];
  List<Map<String, dynamic>> seasonsspeciallist = [];

  late Future<void> fetchData;

  @override
  void initState() {
    super.initState();
    fetchData = fetchJsonData();
  }

  Future<void> fetchJsonData() async {
    final url = Uri.parse("http://iphone.us2guntur.com/AlltypeCategoriesList");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        allTimeGreatGiftsList = List.from(jsonData["Alltimegreatgiftslist"]);
        allCategoriesList = List.from(jsonData["Allcategories list"]);
        homePageProducts1 = List.from(jsonData["HomePageProducts1"]);
        homePageProducts = List.from(jsonData["HomePageProducts"]);
        seasonsspeciallist = List.from(jsonData["seasonsspeciallist"]);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          // If there is a previous route, pop it
          Navigator.of(context).pop();
        } else {
          // If there are no previous routes, exit the app
          SystemNavigator.pop(); // This will exit the app
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Http Request/response',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<void>(
            future: fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Column(
                  children: <Widget>[
                    // Rest of your code remains unchanged...

                    // All Time Great Gifts List
                    AppBar(
                      title: Text('All Time Great Gifts List'),
                      automaticallyImplyLeading: false,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allTimeGreatGiftsList.length,
                      itemBuilder: (context, index) {
                        final item = allTimeGreatGiftsList[index];
                        return GestureDetector(
                          child: ListTile(
                            leading: Image.network(item['imagepath']),
                            title: Text(item['categoryname']),
                            subtitle: Text(item['category_id']),
                          ),
                        );
                      },
                    ),

                    // Home Page Products 1
                    AppBar(
                      title: Text('Home Page Products 1'),
                      automaticallyImplyLeading: false,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homePageProducts1.length,
                      itemBuilder: (context, index) {
                        final item = homePageProducts1[index];
                        return GestureDetector(
                          child: ListTile(
                            leading: Image.network(item['product_zoom_image']),
                            title: Text(item['product_name']),
                            subtitle: Text(item['category_id']),
                          ),
                        );
                      },
                    ),

                    // Home Page Products
                    AppBar(
                      title: Text('Home Page Products'),
                      automaticallyImplyLeading: false,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homePageProducts.length,
                      itemBuilder: (context, index) {
                        final item = homePageProducts[index];
                        return GestureDetector(
                          child: ListTile(
                            leading: Image.network(item['product_zoom_image']),
                            title: Text(item['product_name']),
                            subtitle: Text(item['category_id']),
                          ),
                        );
                      },
                    ),

                    // All Categories List
                    AppBar(
                      title: Text('All Categories List'),
                      automaticallyImplyLeading: false,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allCategoriesList.length,
                      itemBuilder: (context, index) {
                        final item = allCategoriesList[index];
                        return GestureDetector(
                          child: ListTile(
                            leading: Image.network(item['image_path']),
                            title: Text(item['category_name']),
                            subtitle: Text(item['category_id']),
                          ),
                        );
                      },
                    ),

                    // Seasons Special List
                    AppBar(
                      title: Text('Seasons Special List'),
                      automaticallyImplyLeading: false,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: seasonsspeciallist.length,
                      itemBuilder: (context, index) {
                        final item = seasonsspeciallist[index];
                        return GestureDetector(
                          child: ListTile(
                            leading: Image.network(item['imagepath']),
                            title: Text(item['categoryname']),
                            subtitle: Text(item['category_id']),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
