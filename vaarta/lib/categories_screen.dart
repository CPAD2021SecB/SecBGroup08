import 'package:flutter/material.dart';
import 'package:vaarta/categories_list.dart' as categoriesList;
import 'package:vaarta/feeds.dart';
import 'package:vaarta/home_feeds.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: categoriesList.list == null
          ? const Center(child: CircularProgressIndicator())
          :  GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 25.0),
              padding: const EdgeInsets.all(10.0),
              itemCount: categoriesList.list.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  footer: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: SizedBox(
                            height: 16.0,
                            width: 100.0,
                            child: Text(
                              categoriesList.list[index]["name"],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ]),
                  child: Container(
                    height: 500.0,
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      child: Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 40.0,
                                          child: Icon(
                                              categoriesList.list[index]
                                                  ["icon"],
                                              size: 40.0,
                                              color: categoriesList.list[index]
                                                  ["color"]),
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                  Feeds(sourceID: categoriesList.list[index]["name"].toString())
                          ));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}