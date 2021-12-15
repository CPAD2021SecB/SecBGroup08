import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:vaarta/news_model.dart';
import 'package:vaarta/strings.dart';

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
}