import 'sources.dart';

class SourceResponse {
  String? status;
  List<Sources>? sources;

  SourceResponse({this.status, this.sources});

  SourceResponse.fromJson(Map<String, dynamic> json) {
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["sources"] is List) {
      sources =
          json["sources"] == null
              ? null
              : (json["sources"] as List)
                  .map((e) => Sources.fromJson(e))
                  .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if (sources != null) {
      _data["sources"] = sources?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}
