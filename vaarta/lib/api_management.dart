import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:vaarta/news_model.dart';
import 'package:vaarta/strings.dart';

class API_Management {

  Future<NewsModel> getNews() async {
    var client = http.Client();

    var newsmodel = null;

try {
    var response = await client.get(Uri.parse(Strings.newsurl));

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