import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/consts/api_const.dart';
import 'package:news_app/model/news_model.dart';

class NewsApiService {
  static Future<List<Article>> getAllNews(
      {required int page, required String sortBy}) async {
    try {
      List<Article> allNews = [];
      var link = Uri.parse(
          "https://newsapi.org/v2/everything?q=bitcoin&apiKey=13a95b5efb8a4d708191f4072ba75e0e&page=$page&pageSize=5");
      /* var link = Uri.https(baseUrl,"/v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "bbc.co.uk, techcrunch.com, engadget.com",
        "page": page.toString(),
        "sortBy": "$sortBy"
        // "apiKey":apiKey
      });*/

      var responce =
          await http.get(Uri.parse("$link"), headers: {"X-Api-Key": apiKey});
      var data = jsonDecode(responce.body);
      print("All Data are :$data");
      Article article;
      if (data["code"] != null) {
        throw data["message"];
      }
      for (var i in data["articles"]) {
        article = Article.fromJson(i);
        allNews.add(article);
      }
      print("All news length is ${allNews.length}");
      return allNews;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<Article>> getTopHeadlines() async {
    try {
      List<Article> allNews = [];
      var link = Uri.https(baseUrl, "/v2/top-headlines", {
        "country": "us"
        // "apiKey":apiKey
      });

      var responce = await http.get(link, headers: {"X-Api-Key": apiKey});
      var data = jsonDecode(responce.body);
      print("All Data areeeeeeeeeeeee :$data");
      Article article;
      if (data["code"] != null) {
        throw data["message"];
      }
      for (var i in data["articles"]) {
        article = Article.fromJson(i);
        allNews.add(article);
      }
      print("All news length is ${allNews.length}");
      return allNews;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<Article>> saerchNews({required String query}) async {
    try {
      List<Article> allNews = [];
      var link = Uri.https(baseUrl, "/v2/everything", {
        "q": "$query",
        "pageSize": "5",
        "domains": "techcrunch.com",
        // "apiKey":apiKey
      });

      var responce = await http.get(link, headers: {"X-Api-Key": apiKey});
      var data = jsonDecode(responce.body);
      print("All Data are :$data");
      Article article;
      if (data["code"] != null) {
        throw data["message"];
      }
      for (var i in data["articles"]) {
        article = Article.fromJson(i);
        allNews.add(article);
      }
      print("All news length is ${allNews.length}");
      return allNews;
    } catch (e) {
      throw e.toString();
    }
  }
}
