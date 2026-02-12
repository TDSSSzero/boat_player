class VideoDetail {
  final String bvid;
  final int aid;
  final int cid;
  final String title;
  final String pic;
  final List<VideoPage> pages;

  VideoDetail({
    required this.bvid,
    required this.aid,
    required this.cid,
    required this.title,
    required this.pic,
    required this.pages,
  });

  factory VideoDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    var pagesList = <VideoPage>[];
    if (data['pages'] != null) {
      pagesList = (data['pages'] as List).map((e) => VideoPage.fromJson(e)).toList();
    }

    return VideoDetail(
      bvid: data['bvid'] ?? '',
      aid: data['aid'] ?? 0,
      cid: data['cid'] ?? 0,
      title: data['title'] ?? '',
      pic: data['pic'] ?? '',
      pages: pagesList,
    );
  }
}

class VideoPage {
  final int cid;
  final int page;
  final String part;
  final int duration;

  VideoPage({
    required this.cid,
    required this.page,
    required this.part,
    required this.duration,
  });

  factory VideoPage.fromJson(Map<String, dynamic> json) {
    return VideoPage(
      cid: json['cid'] ?? 0,
      page: json['page'] ?? 1,
      part: json['part'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}
