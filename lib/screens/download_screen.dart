import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  static const String id = 'download_screen';
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var downloading = false;
  var progressString = "";
  var downloadedMesage = "";
  double progressValue;
  bool isLinkValid = false;
  TextEditingController _linkTextController = TextEditingController();

  @override
  void initState() {
    _linkTextController.addListener(() {
      if (_linkTextController.text
              .contains('https://www.youtube.com/watch?v=') ||
          _linkTextController.text.contains('https://youtu.be/'))
        setState(() {
          isLinkValid = true;
        });
      else
        setState(() {
          isLinkValid = false;
        });
    });
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSetting = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Custom Download',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              SizedBox(height: 24),
              (!downloading)
                  ? Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _linkTextController,
                        decoration: InputDecoration(
                            labelText: 'Video Link',
                            border: OutlineInputBorder()),
                      ),
                    )
                  : Offstage(),
              (!downloading)
                  ? RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Colors.orange,
                      child: Text(
                        'Download',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                      onPressed: (isLinkValid)
                          ? () {
                              downloadVideo(_linkTextController.text);
                            }
                          : null,
                    )
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

    _linkTextController.clear();

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
      downloadedMesage = "file stored at $path";
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
    if (progressString == '100%') {
      showNotificatio('Download Complete');
    }
    return;
  }

  showNotificatio(String msg) async {
    var android = AndroidNotificationDetails(
        'channel Id', 'channel Name', 'channel Description');
    var iOS = IOSNotificationDetails();
    var initSetting = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'DownTube', '$msg', initSetting);
  }
}
