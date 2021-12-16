// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vaarta/api_management.dart';
import 'package:vaarta/source_news_model.dart';
import './global_store.dart' as global_store;

class Feeds extends StatefulWidget {
  final String sourceID;
  const Feeds({Key? key, required this.sourceID, sourceId}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {

  Future<SourceNewsModel>? _newsmodel;
  late DataSnapshot dbsnapshot;

  @override
  void initState() {
    //getData().whenComplete(() => _newsmodel = API_Management().getNewsfromSource(widget.sourceID));
    _newsmodel = API_Management().getNewsfromSource(widget.sourceID);
    super.initState();
  }

  Future<DataSnapshot> getData() async {
    return global_store.articleSourcesDatabaseReference.once();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<SourceNewsModel>(
            future: _newsmodel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data!.totalResults == 0) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Vaarta | "+ widget.sourceID),
                    ),
                    body: Center(
                      child: Text('No Articles for "'+ widget.sourceID+'" please try other categories'),
                    ),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                      title: Text("Vaarta | "+ widget.sourceID),
                    ),
                  body: ListView.builder(
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
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                        child: Text(
                                          article.description,
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          showDialogFunc(context, article);
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  showDialogFunc(BuildContext context, Article article) {
    log(article.description);
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.7,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        article.title,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(article.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 30),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}