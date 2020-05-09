// class YoutubeVideo {
//   final String id;
//   final String title;
//   final String thumbnailUrl;
//   final String channelTitle;
//   final String description;
//   final String publishedAt;

//   YoutubeVideo({
//     this.id,
//     this.title,
//     this.thumbnailUrl,
//     this.channelTitle,
//     this.description,
//     this.publishedAt,
//   });

//   factory YoutubeVideo.fromMap(Map<String, dynamic> snippet) {
//     return YoutubeVideo(
//       // id: snippet['resourceId']['id'],
//       title: snippet['title'],
//       description: snippet['description'],
//       thumbnailUrl: snippet['thumbnails']['high']['url'],
//       channelTitle: snippet['channelTitle'],
//       publishedAt: snippet['publishedAt'],
//       // id: data['id'],
//       // title: data['snippet']['title'],
//       // description: data['snippet']['description'],
//       // thumbnailUrl: data['snippet']['thumbnails']['high']['url'],
//       // channelTitle: data['snippet']['channelTitle'],
//       // publishedAt: data['snippet']['publishedAt'],
//     );
//   }
// }

class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String description;

  YoutubeVideo({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.description,
  });

  factory YoutubeVideo.fromMap(Map<String, dynamic> snippet) {
    return YoutubeVideo(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
    );
  }
}
