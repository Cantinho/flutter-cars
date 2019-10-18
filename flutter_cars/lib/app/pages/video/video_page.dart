import 'package:flutter/material.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final Car _car;

  VideoPage(this._car);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;

  Car get car => widget._car;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(car.urlVideo ?? "")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.pause();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blendedRed(),
        title: Text(car.name ?? ""),
      ),
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(
                child: Center(
                  child: Text("The car has no video available."),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blendedRed(),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
