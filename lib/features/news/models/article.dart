class Article {
  const Article({
    required this.title,
    required this.url,
    this.summary,
    this.content,
    this.imageUrl,
    this.source,
    this.author,
    this.publishedAt,
  });

  final String title;
  final String url;
  final String? summary;
  final String? content;
  final String? imageUrl;
  final String? source;
  final String? author;
  final DateTime? publishedAt;

  factory Article.fromJson(Map<String, dynamic> json) {
    final sourceData = json['source'];
    final sourceName =
        sourceData is Map<String, dynamic> ? sourceData['name'] : null;
    final publishedAt = json['publishedAt'];

    return Article(
      title: json['title'] as String,
      url: json['url'] as String,
      summary: _nonEmptyString(json['description']),
      content: _nonEmptyString(json['content']),
      imageUrl: _nonEmptyString(json['urlToImage']),
      source: _nonEmptyString(sourceName),
      author: _nonEmptyString(json['author']),
      publishedAt:
          publishedAt is String ? DateTime.tryParse(publishedAt) : null,
    );
  }

  static String? _nonEmptyString(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value;
    return null;
  }
}
