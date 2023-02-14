// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';
 import 'package:flutter/material.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));


class NewsModel {
  NewsModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  final String ?status;
  final int ?totalResults;
  final List<Article> ?articles;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    status: json["status"] == null ? null : json["status"],
    totalResults: json["totalResults"] == null ? null : json["totalResults"],
    articles: json["articles"] == null ? null : List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
  );


}

class Article with ChangeNotifier{
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.readingTimeText,this.dateToShow
  });

  final Source? source;
  final String ?author;
  final String ?title;
  final String ?description;
  final String ?url;
  final String ?urlToImage;
  final String ?publishedAt;
  final String? content;
  final String?  readingTimeText,dateToShow;

  factory Article.fromJson(Map<String, dynamic> json) {
    String title= json["title"] == null ? null : json["title"];
    String content=json["content"] == null ? null : json["content"];
    String description=json["description"] == null ? null : json["description"];
    String dateToShow= GlobalMethods.formattedDateText(json["publishedAt"]);
    return  Article(
      source: json["source"] == null ? null : Source.fromJson(json["source"]),
      author: json["author"] == null ? "null" : json["author"],
      title: title,
      description:description,
      url: json["url"] == null ? null : json["url"],
      urlToImage: json["urlToImage"] == null ? null : json["urlToImage"],
      publishedAt: json["publishedAt"] == null ? null : json["publishedAt"],
      content: content,
dateToShow: dateToShow,
      readingTimeText: readingTime(title + description + content).msg,
    );
  }


}

class Source {
  Source({
    this.id,
    this.name,
  });

  final String ?id;
  final String? name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    id: json["id"] == null ? "null" : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
