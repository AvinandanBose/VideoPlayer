import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? videoPlayerController;
  bool isLoop=false;

  playPauseVideo() async {
    if (videoPlayerController!.value.volume == 0 &&
        videoPlayerController!.value.isPlaying) {
      videoPlayerController!.setVolume(1.0);
      setState(() {});
    } else if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.setVolume(0.0);
      await videoPlayerController!.pause();
      setState(() {});
    } else {
      videoPlayerController!.setVolume(1.0);
      await videoPlayerController!.play();
      setState(() {});
    }
  }





  Future<void> setupVideo() async {
    videoPlayerController =
        VideoPlayerController.asset('assets/BlindingLights.mp4')
          ..addListener(() => setState(() {}))
          ..initialize().then((value) => videoPlayerController?.play());
  }

  Future<void> setLoop()async{
    return await videoPlayerController?.setLooping(isLoop);
  }
  Future<void> fastForward()async{

    return await videoPlayerController?.setPlaybackSpeed(2.0);
  }
  Future<void> fastForwardReset()async{

    return await videoPlayerController?.setPlaybackSpeed(1.0);
  }

  @override
  void initState() {
    super.initState();
    setupVideo();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Video Player'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 24.0),
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 200.0,
                      width: 170.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: videoPlayerController != null &&
                                videoPlayerController!.value.isInitialized
                            ? Column(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child:
                                        videoPlayerController!.value.isPlaying
                                            ? GestureDetector(
                                                onTap: () => playPauseVideo(),
                                                child: VideoPlayer(
                                                    videoPlayerController!))
                                            : const Icon(Icons.play_arrow,
                                                color: Colors.black,
                                                size: 80.0),
                                  ),
                                  Expanded(
                                    child: VideoProgressIndicator(
                                        videoPlayerController!,
                                        allowScrubbing: true),
                                  )
                                ],
                              )
                            : Container(
                                height: 200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (videoPlayerController != null &&
                videoPlayerController!.value.isInitialized)
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => playPauseVideo(),
                      icon: Icon(
                          videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_circle_filled,
                          color: Colors.greenAccent,
                          size: 50),
                    ),
                    IconButton(
                      onPressed: () {
                        setState((){
                          isLoop = true;
                          setLoop();
                        });

                      },
                      icon: Icon(
                          videoPlayerController!.value.isPlaying && isLoop==false
                              ? Icons.repeat
                              : Icons.repeat_one,
                          color: Colors.greenAccent,
                          size: 50),
                    ),
                    IconButton(
                      onPressed: () {
                        setState((){
                          isLoop = false;
                          setLoop();
                        });

                      },
                      icon: Icon(
                          videoPlayerController!.value.isPlaying && isLoop==false
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: Colors.greenAccent,
                          size: 50),
                    ),
                    IconButton(
                      onPressed: () => fastForward(),

                      icon: const Icon(Icons.fast_forward,

                          color: Colors.greenAccent,
                          size: 50),
                    ),
                    IconButton(
                      onPressed: () => fastForwardReset(),

                      icon: const Icon(Icons.fast_rewind,

                          color: Colors.greenAccent,
                          size: 50),
                    ),


                  ],



                ),
              ),
          ],
        ),
      ),
    );
  }
}
