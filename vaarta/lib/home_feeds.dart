// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vaarta/api_management.dart';
import 'package:vaarta/news_model.dart';
import './global_store.dart' as global_store;

class HomeFeeds extends StatefulWidget {
  const HomeFeeds({Key? key}) : super(key: key);
  


  @override
  _HomeFeedsState createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {

  Future<NewsModel>? _newsmodel;
    Future<DataSnapshot>? snapshot;
    Future<DataSnapshot>? articlesnap;


  @override
  void initState() {
    articlesnap = getArticleData();
    snapshot = getData();
    super.initState();
  }

  Future<DataSnapshot> getData() async {
    return await global_store.articleSourcesDatabaseReference.once();
  }

  
  Future<DataSnapshot> getArticleData() async {
    return await global_store.articleDatabaseReference.once();
  }

  _hasArticle(article, articlesnapshot) {
    if (articlesnapshot!.value != null) {
      var value = articlesnapshot!.value;
      int flag = 0;
      if (value != null) {
        value.forEach((k, v) {
          if (v['url'].compareTo(article.url) == 0) {
            flag = 1;
            return;
          }
        });
        if (flag == 1) return true;
      }
    }
    return false;
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, color: color),
      ],
    );
  }

  _onBookmarkTap(article, articlesnapshot) {
    if (articlesnapshot!.value != null) {
      var value = articlesnapshot!.value;
      int flag = 0;
      value.forEach((k, v) {
        if (v['url'].compareTo(article.url) == 0) {
          flag = 1;
          global_store.articleDatabaseReference.child(k).remove();
          Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Article removed'),
                backgroundColor: Colors.grey[600],
              ));
        }
      });
      if (flag != 1) {
        Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Article saved'),
              backgroundColor: Colors.grey[600],
            ));
        pushArticle(article);
      }
    } else {
      pushArticle(article);
    }
    //snapshot = getData() as DataSnapshot?;
    //articlesnap = getArticleData() as DataSnapshot?;
    build(context);
  }

  pushArticle(article) {
    global_store.articleDatabaseReference.push().set({
      'description': article.description,
      'title': article.title,
      'url': article.url,
      'urlToImage': article.urlToImage,
    });
  }

  
  @override
  Widget build (BuildContext context) {
        DataSnapshot? ssnapshot;
    DataSnapshot? articlesnapshot;

    return Scaffold(
      body: Container(
        child: FutureBuilder<DataSnapshot>(
          future: articlesnap,
          builder: (context,sn) {
            if(sn.hasData){
              articlesnapshot = sn.data;
            return Container(
              child: FutureBuilder<DataSnapshot>(
                future: snapshot,
                builder: (context,snapp) {
                  if(snapp.hasData) {
                  ssnapshot = snapp.data;
                  _newsmodel = API_Management().getNews(ssnapshot);
                  return Container(
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
                              ),
                              GestureDetector(
                                                      child:  Padding(
                                                          padding:
                                                               const EdgeInsets.all(5.0),
                                                          child: _hasArticle(snapshot.data!.articles[index], articlesnapshot)
                                                              ? buildButtonColumn(
                                                                  Icons.bookmark)
                                                              : buildButtonColumn(Icons
                                                                  .bookmark_border)),
                                                      onTap: () {
                                                        _onBookmarkTap(snapshot.data!.articles[index], articlesnapshot);
                                                      },
                                                    ),
                          ],
                          ),
                        );
                      }
                      );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());

                }
              ),
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