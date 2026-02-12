class PlayUrlResponse {
  final List<DashStream> audioStreams;

  PlayUrlResponse({required this.audioStreams});

  factory PlayUrlResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null || data['dash'] == null || data['dash']['audio'] == null) {
      return PlayUrlResponse(audioStreams: []);
    }

    final audioList = (data['dash']['audio'] as List)
        .map((e) => DashStream.fromJson(e))
        .toList();
    
    return PlayUrlResponse(audioStreams: audioList);
  }
}

class DashStream {
  final int id;
  final String baseUrl;
  final int bandwidth;
  final String mimeType;
  final String codecs;

  DashStream({
    required this.id,
    required this.baseUrl,
    required this.bandwidth,
    required this.mimeType,
    required this.codecs,
  });

  factory DashStream.fromJson(Map<String, dynamic> json) {
    return DashStream(
      id: json['id'] ?? 0,
      baseUrl: json['baseUrl'] ?? json['base_url'] ?? '',
      bandwidth: json['bandwidth'] ?? 0,
      mimeType: json['mimeType'] ?? json['mime_type'] ?? '',
      codecs: json['codecs'] ?? '',
    );
  }
}
