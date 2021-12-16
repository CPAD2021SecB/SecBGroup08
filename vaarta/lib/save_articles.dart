import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vaarta/news_model.dart';

import './global_store.dart' as global_store;


class SaveArticles extends StatefulWidget {
  const SaveArticles({Key? key}) : super(key: key);

  @override
  _SaveArticlesState createState() => _SaveArticlesState();
}

class _SaveArticlesState extends State<SaveArticles> {
  
  DataSnapshot? articlesnap;

  @override
  void initState() {
    
    super.initState();
  }

  
  Future<DataSnapshot> getArticleData() async {
    return await global_store.articleDatabaseReference.once();
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getArticleData(),
          builder: (context,sn) {
            if(sn.hasData){
              articlesnap = sn.data as DataSnapshot?;
              var value = articlesnap!.value;
               return Container(
          padding:  const EdgeInsets.all(32.0),
          child:  Center(
            child:  Column(
              children: <Widget>[
                 
                /*Listview diplay rows for different widgets,
                Listview.builder automatically builds its child widgets with a
                template and a list*/

                 Expanded(child:  ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index){
                    String key = value.keys.elementAt(index);
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
                                    value[key]['urlToImage'],
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
                                      value[key]['title'], 
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      child: Text(
                                        value[key]['description'], 
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        showDialogFunc(context, value[key]);
                                      }
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          ),
                        );
                    
                    
                    /*return  Row(
                      children: <Widget>[
                         Text('$key : '),
                         Text(value[key]['title'])
                      ],
                    );*/
                  },

                ))

              ],
            ),
          )
      );
            } else { return const Center(child: CircularProgressIndicator()); };
          }),
      ),
    );
  }

  showDialogFunc(BuildContext context, Map  article) {
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
                        article['urlToImage'],
                        height: 100,
                      ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    article['title'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Flexible(
                    child: Text(
                      article['description'],
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