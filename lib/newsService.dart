import 'dart:convert';
import 'package:http/http.dart' as http;
import 'newsModel.dart';

class NewsService {
  static const String apiKey = 'ab68229b2c12481882d2dc489698672d';
  static const String baseUrl = 'https://newsapi.org/v2';

  // Fetch berita berdasarkan kategori (untuk halaman Beranda)
  Future<List<NewsModel>> fetchNews({String category = 'All'}) async {
    String url = '$baseUrl/top-headlines?apiKey=$apiKey&country=us';
    
    if (category != 'All') {
      url += '&category=${category.toLowerCase()}'; // Menambahkan kategori ke URL
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Fungsi untuk mencari berita berdasarkan query
  Future<List<NewsModel>> searchNews({required String query}) async {
    String url = '$baseUrl/everything?apiKey=$apiKey&q=$query';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}
