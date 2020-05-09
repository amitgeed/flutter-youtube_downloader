import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownload extends StatefulWidget {
  static const String id = 'video_download';

  final String videoUrl;

  VideoDownload({this.videoUrl});

  @override
  _VideoDownloadState createState() => _VideoDownloadState();
}

class _VideoDownloadState extends State<VideoDownload> {
  var downloading = false;
  var progressString = "";
  var downloadedMesage = "";
  double progressValue;

  @override
  void initState() {
    super.initState();
    downloadVideo(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Do Not Press Back Button',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                (!downloading) ? Container() : Offstage(),
                (!downloading)
                    ? Container()
                    : Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: progressValue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Downloading file $progressString'),
                            )
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(downloadedMesage),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void downloadVideo(String videoURL) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        downloadedMesage = "No Internet";
      });
      return;
    }

    setState(() {
      downloading = true;
      downloadedMesage = "Fetching links";
    });
    const platform = const MethodChannel('videoLink');
    Map<dynamic, dynamic> videoLinks = await platform.invokeMethod(
        'videoLinks', {'videoLink': videoURL}).catchError((error) {
      setState(() {
        downloadedMesage = error.toString();
      });
    });

    setState(() {
      downloading = false;
      downloadedMesage = "";
    });

    List<String> titles = List();
    videoLinks.keys.forEach((f) {
      titles.add(f.toString());
    });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      setState(() {
                        downloading = true;
                        downloadedMesage = "";
                      });

                      if (videoLinks[titles[index]] != null) {
                        _downloadFile(videoLinks[titles[index]], titles[index]);
                      }
                      Navigator.of(context).pop();
                    },
                    title: Text(titles[index]),
                  );
                }),
          );
        });
  }

  Future<void> _downloadFile(String url, String filename) async {
    setState(() {
      downloadedMesage = "";
    });
    Dio dio = Dio();
    try {
      String dir = (await getExternalStorageDirectory()).path;
      String path = '$dir/$filename';
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        setState(() {
          progressValue = ((rec / total));
          progressString = (progressValue * 100).toStringAsFixed(0) + "%";
        });
      });
      setState(() {
        downloadedMesage = "file stored at $path";
      });
      downloadedMesage = "file stored at $path \n Now You Can Go Back";
      print("file stored at $path");
    } catch (e) {
      print(e);
      setState(() {
        downloadedMesage = "Some error occurred";
      });
    }

    setState(() {
      downloading = false;
      progressValue = null;
      progressString = "";
    });
    return;
  }
}
