class VideoItem {
  final int aid;
  final String bvid;
  final String title;
  final String pic;
  final int play;
  final int comment;
  final String author;
  final int mid;
  final int created;
  final String length;
  final String? description;

  VideoItem({
    required this.aid,
    required this.bvid,
    required this.title,
    required this.pic,
    required this.play,
    required this.comment,
    required this.author,
    required this.mid,
    required this.created,
    required this.length,
    this.description,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      aid: json['aid'] ?? 0,
      bvid: json['bvid'] ?? '',
      title: json['title'] ?? '',
      pic: json['pic'] ?? '',
      play: json['play'] ?? 0,
      comment: json['comment'] ?? 0,
      author: json['author'] ?? '',
      mid: json['mid'] ?? 0,
      created: json['created'] ?? 0,
      length: json['length'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aid': aid,
      'bvid': bvid,
      'title': title,
      'pic': pic,
      'play': play,
      'comment': comment,
      'author': author,
      'mid': mid,
      'created': created,
      'length': length,
      'description': description,
    };
  }
}

class SpaceArcSearchResponse {
  final List<VideoItem> vlist;
  final int count;

  SpaceArcSearchResponse({
    required this.vlist,
    required this.count,
  });

  factory SpaceArcSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null) {
      return SpaceArcSearchResponse(vlist: [], count: 0);
    }
    
    final listData = data['list'];
    final pageData = data['page'];
    
    List<VideoItem> vlist = [];
    if (listData != null && listData['vlist'] != null) {
      vlist = (listData['vlist'] as List)
          .map((e) => VideoItem.fromJson(e))
          .toList();
    }

    int count = 0;
    if (pageData != null) {
      count = pageData['count'] ?? 0;
    }

    return SpaceArcSearchResponse(vlist: vlist, count: count);
  }
}
