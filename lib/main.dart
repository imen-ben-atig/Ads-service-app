import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Mode App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFullScreen = false;
  String i = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              title: Text('Full Screen'),
              value: isFullScreen,
              onChanged: (value) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]);

                setState(() {
                  isFullScreen = value!;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoInfo(isFullScreen: isFullScreen),
                    ),
                  );
                  debugPrint(i = 'after tick 11  ' + isFullScreen.toString());
                });
              },
            ),
            CheckboxListTile(
              title: Text('Normal'),
              value: !isFullScreen,
              onChanged: (value) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                setState(() {
                  isFullScreen = !value!;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoInfo(isFullScreen: isFullScreen),
                    ),
                  );
                });
              },
            ),
            FloatingActionButton(
              onPressed: _refreshData,
              tooltip: 'Refresh',
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate a delay to show the refresh indicator.
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }
}

class VideoInfo extends StatefulWidget {
  final bool isFullScreen;

  VideoInfo({required this.isFullScreen});

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;
  VideoPlayerController? _controller;

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoInfo.json")
        .then((value) {
      setState(() {
        // so we can update the screen every time we have a new info
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
    _initData();
  }

//////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          _playView(context),
          _controlView(context),
        ],
      ),
    ));
  }

  ////////////////////////////////////////////////////////////////////

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _controlView(BuildContext context) {
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final index = _isPlayingIndex - 1;
                if (index >= 0) {
                  _initializedVideo(index);
                } else {
                  Get.snackbar(
                    "Video list",
                    "",
                    snackPosition: SnackPosition.BOTTOM,
                    icon: Icon(
                      Icons.face,
                      size: 20,
                      color: Colors.black,
                    ),
                    colorText: Colors.black,
                    messageText: Text(
                      "that's the first video! ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.fast_rewind,
                size: 30,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_isPlaying) {
                  setState(() {
                    _isPlaying = false;
                  });
                  _controller?.pause();
                } else {
                  setState(() {
                    _isPlaying = true;
                  });
                  _controller?.play();
                }
              },
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () async {
                final index = _isPlayingIndex + 1;
                if (index <= videoInfo.length - 1) {
                  _initializedVideo(index);
                } else {
                  Get.snackbar(
                    "Video list",
                    "",
                    snackPosition: SnackPosition.BOTTOM,
                    icon: Icon(
                      Icons.face,
                      size: 20,
                      color: Colors.black,
                    ),
                    colorText: Colors.black,
                    messageText: Text(
                      "no more videos to play ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.fast_forward,
                size: 30,
                color: Colors.black,
              ),
            ),
            Text("$mins:$secs",
                style: TextStyle(color: Colors.black, shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.1),
                    blurRadius: 4.0,
                    color: Color.fromARGB(150, 0, 0, 0),
                  )
                ])),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //_playView(context),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the homepage
              Navigator.pop(context);
            },
            child: Text('Back '),
          ),
        ])
      ]))
    ]);
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(children: [
          VideoPlayer(controller),
          SizedBox(
            height: 200,
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 2.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: max(0, min(_progress * 100, 100)),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: _position?.toString().split(".")[0],
                  onChanged: (value) {
                    setState(() {
                      _progress = value * 0.01;
                    });
                  },
                  onChangeStart: (value) {
                    _controller?.pause();
                  },
                  onChangeEnd: (value) {
                    final duration = _controller?.value.duration;
                    if (duration != null) {
                      var newValue = max(0, min(value, 99)) * 0.01;
                      var millis = (duration.inMilliseconds * newValue).toInt();
                      _controller?.seekTo(Duration(milliseconds: millis));
                      _controller?.play();
                    }
                  },
                )),
          ),
          _controlView(context),
        ]),
      );
    } else {
      return AspectRatio(
          aspectRatio: 10 / 1,
          child: Center(
              child: Text(
            " Prepearing ...",
            style: TextStyle(fontSize: 20, color: Colors.black),
          )));
    }
  }

  var _onUpdateControllerTime;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;

  void _oncontrollerUpdate() async {
    if (_disposed) {
      return;
    }
    _onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }
    _onUpdateControllerTime = now + 500;

    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("cont cannot be init");
      return;
    }

    if (_duration == null) {
      _duration = _controller?.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;
    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  _initializedVideo(int index) async {
    final controller = VideoPlayerController.network(videoInfo[index]["url"]);
    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_oncontrollerUpdate);
      old.pause();
    }

    setState(() {});
    controller.initialize().then((_) {
      old?.dispose();
      _isPlayingIndex = index;
      controller.addListener(_oncontrollerUpdate);
      controller.play();
      setState(() {});
    });
  }
}
