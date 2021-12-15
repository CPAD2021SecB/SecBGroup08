// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vaarta/home_feeds.dart';

import 'api_management.dart';
import 'news_source_model.dart';
import './global_store.dart' as global_store;

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key? key}) : super(key: key);

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  

  Future<NewsSource>? _sources;

  DataSnapshot? snapshot;

  @override
  void initState(){
    _sources = API_Management().getSources();
    super.initState();
    //getData();//.whenComplete(() => _sources = API_Management().getSources());
    
  }

  
  Future<DataSnapshot> getData() async {
    return await global_store.articleSourcesDatabaseReference.once();
  }

_hasSource(id) {
    if (snapshot!.value != null) {
      var value = snapshot!.value;
      int flag = 0;
      if (value != null) {
        value.forEach((k, v) {
          if (v['id'].compareTo(id) == 0) {
            flag = 1;
          }
        });
        if (flag == 1) return true;
      }
    }
    return false;
  }

  _onAddTap(name, id) {
    if (snapshot!.value != null) {
      var value = snapshot!.value;
      int flag = 0;
      value.forEach((k, v) {
        if (v['id'].compareTo(id) == 0) {
          flag = 1;
          Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('$name removed'),
                backgroundColor: Colors.grey[600],
              ));
          global_store.articleSourcesDatabaseReference.child(k).remove();
        }
      });
      if (flag != 1) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('$name added'),
            backgroundColor: Colors.grey[600]));
        pushSource(name, id);
      }
    } else {
      pushSource(name, id);
    }
      getData();
  }


  pushSource(name, id) {
    global_store.articleSourcesDatabaseReference.push().set({
      'name': name,
      'id': id,
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapp) {
          if(snapp.hasData) {
            snapshot = snapp.data as DataSnapshot?;
          return FutureBuilder<NewsSource>(
            future: _sources,
            builder: (context, snap) {
            if(snap.hasData) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 25.0),
                padding: const EdgeInsets.all(10.0),
                itemCount: _sources == null ? 0 : snap.data!.sources.length,
                itemBuilder: (BuildContext context, int index) {
                  String sourcename = snap.data!.sources[index].name;
                  return GridTile(
                    footer: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[]),
                    child: Container(
                      height: 500.0,
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100.0,
                              width: 80.0,
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        child: Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration:  const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white70
                                          ),
                                          child: Center(
                                            child: Text(sourcename, style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold , fontSize: 11.0),),
                                          )
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        child: GestureDetector(
                                          child: _hasSource(snap.data!.sources[index].id)
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.greenAccent[700],
                                                )
                                              : Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey[500],
                                                ),
                                          onTap: () {
                                            _onAddTap(
                                              snap.data!.sources[index].name,
                                              snap.data!.sources[index].id);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
              return const Center(child: CircularProgressIndicator());
            }
                  );
                  }
           return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}