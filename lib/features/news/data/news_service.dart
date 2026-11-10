import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../data/models/categories_data.dart';
import '../endpoints.dart';
import '../models/article.dart';
import '../news_constants.dart';

class NewsService {
  NewsService({http.Client? client, String? apiKey})
    : _client = client ?? http.Client(),
      _apiKey = apiKey ?? NewsConstants.apiKey;

  static const _timeout = Duration(seconds: 15);

  final http.Client _client;
  final String _apiKey;

  Future<List<Article>> fetchCategory(
    Category category, {
    bool arabic = false,
  }) async {
    final categoryName = switch (category) {
      Category.general => 'general',
      Category.business => 'business',
      Category.sports => 'sports',
      Category.technology => 'technology',
      Category.health => 'health',
      Category.science => 'science',
      Category.entertainment => 'entertainment',
    };

    if (_apiKey.trim().isEmpty) {
      throw Exception(
        'News API key is missing. Run the app with '
        '--dart-define=NEWS_API_KEY=your_api_key.',
      );
    }

    final queryParams = <String, String>{
      'country': 'us',
      'category': categoryName,
      'pageSize': '50',
      'apiKey': _apiKey,
    };

    final uri = Uri.https(
      NewsConstants.baseURL,
      Endpoints.topHeadlinesEndpoint,
      queryParams,
    );

    return _executeRequest(uri);
  }

  Future<List<Article>> getNews(String query, {bool arabic = false}) async {
    if (_apiKey.trim().isEmpty) {
      throw Exception(
        'News API key is missing. Run the app with '
        '--dart-define=NEWS_API_KEY=your_api_key.',
      );
    }
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(query, 'query', 'Search text cannot be empty.');
    }

    final queryParams = <String, String>{
      'q': trimmed,
      'sortBy': 'publishedAt',
      'pageSize': '50',
      'apiKey': _apiKey,
    };

    final uri = Uri.https(
      NewsConstants.baseURL,
      Endpoints.everythingEndpoint,
      queryParams,
    );

    return _executeRequest(uri);
  }

  Future<List<Article>> _executeRequest(Uri uri) async {
    final response = await _client.get(uri).timeout(_timeout);
    final Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected news API response.');
      }
      payload = decoded;
    } on FormatException {
      throw const FormatException('The news service returned invalid data.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        payload['status'] != 'ok') {
      final message = payload['message'];
      throw Exception(
        message is String && message.isNotEmpty
            ? message
            : 'News request failed (${response.statusCode}).',
      );
    }

    final rawArticles = payload['articles'];
    if (rawArticles is! List) {
      throw const FormatException(
        'The news response did not contain articles.',
      );
    }

    return rawArticles
        .whereType<Map<String, dynamic>>()
        .where(_isValidArticle)
        .map(Article.fromJson)
        .toList(growable: false);
  }

  bool _isValidArticle(Map<String, dynamic> json) {
    final title = json['title'];
    final url = json['url'];
    if (title is! String || title.trim().isEmpty || url is! String) {
      return false;
    }

    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  void close() => _client.close();
}
