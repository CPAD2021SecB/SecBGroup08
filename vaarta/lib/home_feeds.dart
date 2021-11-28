// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vaarta/api_management.dart';
import 'package:vaarta/news_model.dart';

class HomeFeeds extends StatefulWidget {
  const HomeFeeds({Key? key}) : super(key: key);
  


  @override
  _HomeFeedsState createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {

  Future<NewsModel>? _newsmodel;

  @override
  void initState() {
    _newsmodel = API_Management().getNews();
    super.initState();
  }
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<NewsModel>(
          future: _newsmodel,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.articles.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data!.articles[index];
            return Container(
              decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: Colors.white70,
  ),
              height: 100,
              margin: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        article.urlToImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Text(
                          article.title, 
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          child: Text(
                            article.description, 
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            showDialogFunc(context, article);
                          }
                        ),
                      ],
                    ),
                  )
              ],
              ),
            );
          }
          );
            }
            return const Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }

  showDialogFunc(BuildContext context, Article  article) {
    log(article.description);
    return showDialog(
      context: context, 
      builder: (context){
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width*0.7,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                        article.urlToImage,
                        height: 100,
                      ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Flexible(
                    child: Text(
                      article.description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 30
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      });
  }
}