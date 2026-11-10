import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:news_app/data/models/categories_data.dart';
import 'package:news_app/features/news/data/news_service.dart';

void main() {
  test('requests English news and parses the JSON response', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'newsapi.org');
      expect(request.url.path, '/v2/everything');
      expect(request.url.queryParameters['q'], 'UAE business');
      expect(request.url.queryParameters['language'], 'en');
      expect(request.url.queryParameters['apiKey'], 'test-key');
      return http.Response(
        jsonEncode({
          'status': 'ok',
          'articles': [
            {
              'title': 'UAE & the region',
              'url': 'https://example.com/article',
              'description': 'Latest update',
              'source': {'name': 'Gulf News'},
              'publishedAt': '2026-10-28T05:02:00Z',
            },
            {'title': null, 'url': 'https://example.com/no-title'},
            {'title': 'No URL', 'url': null},
          ],
        }),
        200,
      );
    });
    final service = NewsService(client: client, apiKey: 'test-key');
    addTearDown(service.close);

    final articles = await service.fetchCategory(Category.business);

    expect(articles, hasLength(1));
    expect(articles.single.title, 'UAE & the region');
    expect(articles.single.summary, 'Latest update');
    expect(articles.single.source, 'Gulf News');
    expect(articles.single.publishedAt, DateTime.utc(2026, 10, 28, 5, 2));
  });

  test('requests Arabic headlines and category terms', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['q'], 'الإمارات رياضة');
      expect(request.url.queryParameters['language'], 'ar');
      return http.Response('{"status":"ok","articles":[]}', 200);
    });
    final service = NewsService(client: client, apiKey: 'test-key');
    addTearDown(service.close);

    expect(await service.fetchCategory(Category.sports, arabic: true), isEmpty);
  });

  test('reports API errors', () async {
    final client = MockClient(
      (_) async => http.Response(
        '{"status":"error","code":"apiKeyInvalid","message":"Invalid API key"}',
        401,
      ),
    );
    final service = NewsService(client: client, apiKey: 'test-key');
    addTearDown(service.close);

    await expectLater(
      service.getNews('UAE'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('Invalid API key'),
        ),
      ),
    );
  });

  test('explains when no API key is configured', () async {
    final client = MockClient((_) async {
      fail('A request should not be sent without an API key.');
    });
    final service = NewsService(client: client, apiKey: '');
    addTearDown(service.close);

    await expectLater(
      service.getNews('UAE'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('NEWS_API_KEY'),
        ),
      ),
    );
  });
}
