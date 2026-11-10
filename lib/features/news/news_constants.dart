class NewsConstants {
  static const String baseURL = 'newsapi.org';

  static const String apiKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: _hardcodedKey,
  );

  static const String _hardcodedKey = '';
}
