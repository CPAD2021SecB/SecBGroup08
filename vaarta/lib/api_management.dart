import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:vaarta/news_model.dart';
import 'package:vaarta/source_news_model.dart';
import 'package:vaarta/strings.dart';
import 'package:vaarta/news_source_model.dart';

class API_Management {

  Future<NewsModel> getNews(DataSnapshot? snapshot) async {
    var client = http.Client();

    var newsmodel = null;

    String queryparam = "techcrunch";

    if (snapshot!.value != null) {
      var value = snapshot.value;
      if (value != null) {
        value.forEach((k, v) {
          queryparam = queryparam + "," +v["id"] ;
        });
      }
    }

try {
    var response = await client.get(Uri.parse(Strings.newsurl+queryparam));

    if(response.statusCode == 200){
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      
      newsmodel = NewsModel.fromJson(jsonMap);
    }
} on Exception {
      return newsmodel;

}

    return newsmodel;

  }
  Future<NewsSource> getSources() async {
    var client = http.Client();
    var sources = null;
try {
    var response = await client.get(Uri.parse(Strings.sourceurl));
    if(response.statusCode == 200){
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);   

      sources = NewsSource.fromJson(jsonMap);
    }

} on Exception {
      print(Exception);
      return sources;
}
    return sources;
  }
  Future<SourceNewsModel>? getNewsfromSource(String sourceID) async {

        var client = http.Client();



    var source_news = null;



try {

    var response = await client.get(Uri.parse(Strings.sourcenewsurl+sourceID));



    if(response.statusCode == 200){

      var jsonString = response.body;

      var jsonMap = json.decode(jsonString);

     

      source_news = SourceNewsModel.fromJson(jsonMap);

    }

} on Exception {

      return source_news;



}



    return source_news;

   

  }
}