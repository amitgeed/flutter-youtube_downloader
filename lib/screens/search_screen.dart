import 'package:flutter_app_youtube_demo/screens/player_screen.dart';
import 'package:flutter_app_youtube_demo/screens/video_download.dart';
import 'package:flutter_app_youtube_demo/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:youtube_api/youtube_api.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'player_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<YT_API> youtubeVideo = [];
  String svideo;

  YoutubeAPI ytApi = new YoutubeAPI(API_KEY);

  _buildVideo(index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image(
                width: 150.0,
                image:
                    NetworkImage(youtubeVideo[index].thumbnail['high']['url']),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      youtubeVideo[index].title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      youtubeVideo[index].channelTitle,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            height: 1.0,
            color: Colors.white30,
          ),
          SizedBox(
            height: 5.0,
          ),
          youtubeVideo[index].kind == 'video'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(
                            id: youtubeVideo[index].id,
                            title: youtubeVideo[index].title,
                            description: youtubeVideo[index].description,
                          ),
                        ),
                      ),
                      child: Card(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "Play",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FlutterShare.share(
                            title: 'Hey there !',
                            text: 'Check this out :',
                            linkUrl:
                                'https://www.youtube.com/watch?v=${youtubeVideo[index].id}',
                            chooserTitle: 'Share Via');
                      },
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "Share",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDownload(
                              videoUrl:
                                  'https://www.youtube.com/watch?v=${youtubeVideo[index].id}',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "Download",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  // _loadMoreVideos() async {
  //   _isLoading = true;
  //   List<YoutubeVideo> moreVideos =
  //       await APIService.instance.fetchYoutubeVideo(query: svideo);
  //   List<YoutubeVideo> allVideos = youtubeVideo..addAll(moreVideos);
  //   setState(() {
  //     youtubeVideo = allVideos;
  //   });
  //   _isLoading = false;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search videos',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                onSubmitted: (value) async {
                  youtubeVideo = await ytApi.search(value);
                  setState(() {
                    if (youtubeVideo.length != -1) {
                      ListView.builder(
                        itemCount: youtubeVideo.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildVideo(index),
                      );
                    }
                  });
                },
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: youtubeVideo.length,
          itemBuilder: (BuildContext context, int index) => _buildVideo(index),
        ),
      ),
    );
  }
}
