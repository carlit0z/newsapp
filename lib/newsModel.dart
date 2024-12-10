class NewsModel {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String url;

  NewsModel({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
  });

  // Factory untuk membuat NewsModel dari JSON
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
    );
  }

  // Konversi NewsModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'url': url,
    };
  }
}
