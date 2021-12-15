// To parse this JSON data, do
//
//     final newsSource = newsSourceFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

NewsSource newsSourceFromJson(String str) => NewsSource.fromJson(json.decode(str));

String newsSourceToJson(NewsSource data) => json.encode(data.toJson());

class NewsSource {
    NewsSource({
        required this.status,
        required this.sources,
    });

    String status;
    List<Source> sources;

    factory NewsSource.fromJson(Map<String, dynamic> json) => NewsSource(
        status: json["status"],
        sources: List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
    };
}

class Source {
    Source({
        required this.id,
        required this.name,
        required this.description,
        required this.url,
        required this.category,
        required this.language,
        required this.country,
    });

    String id;
    String name;
    String description;
    String url;
    Category? category;
    Language? language;
    String country;

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: categoryValues.map[json["category"]],
        language: languageValues.map[json["language"]],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "category": categoryValues.reverse[category],
        "language": languageValues.reverse[language],
        "country": country,
    };
}

enum Category { GENERAL, TECHNOLOGY, BUSINESS, SPORTS, ENTERTAINMENT, HEALTH, SCIENCE }

final categoryValues = EnumValues({
    "business": Category.BUSINESS,
    "entertainment": Category.ENTERTAINMENT,
    "general": Category.GENERAL,
    "health": Category.HEALTH,
    "science": Category.SCIENCE,
    "sports": Category.SPORTS,
    "technology": Category.TECHNOLOGY
});

enum Language { EN }

final languageValues = EnumValues({
    "en": Language.EN
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap = <T,String>{};

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
