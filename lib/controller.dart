import 'dart:async';
import 'dart:ui';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player_app/songListModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    playerProgress();
    // playListMethode();
  }

  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          key: globalKey,
          drawer: Container(
            width: Get.width * .75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ListView.separated(
                itemCount: song.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        selectedIndex.value = index;
                        await player.seek(Duration.zero,
                            index: selectedIndex.value);
                        playerProgress();
                        player.play();
                      },
                      child: Text(
                        song[index].title,
                        style: TextStyle(
                            color: selectedIndex.value == index
                                ? Colors.blue
                                : Colors.black,
                            fontSize: 20),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Divider(
                      thickness: 1,
                    ),
                  );
                },
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/fire.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0)),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: Get.height / 16,
                  left: Get.width / 16,
                  child: GestureDetector(
                    onTap: () {
                      globalKey.currentState!.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  )),
              Positioned(
                top: Get.height / 7,
                left: Get.width / 8,
                right: Get.width / 8,
                child: Container(
                  width: Get.width * .75,
                  height: Get.height / 1.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage('assets/fire.jpg'),
                          fit: BoxFit.cover)),
                ),
              ),
              Positioned(
                bottom: Get.height / 5,
                left: Get.width / 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Set Fire to the Rain',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'Saturday',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: Get.height / 8.5,
                  right: Get.width / 16,
                  left: Get.width / 16,
                  child: Obx(
                    () => ProgressBar(
                      thumbColor: Colors.white,
                      progressBarColor: Colors.white,
                      timeLabelPadding: 20,
                      progress: progressValue.value,
                      total: player.duration ?? const Duration(seconds: 0),
                      onSeek: (value) => player.seek(value),
                    ),
                  )),
              Positioned(
                bottom: Get.height / 17,
                left: Get.width / 16,
                right: Get.width / 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        playerProgress();
                        player.seekToPrevious();
                      },
                      child: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () async {
                          playingState.value = !playingState.value;
                          playingState.value
                              ? await player.play()
                              : await player.pause();
                        },
                        child: playingState.value
                            ? const Icon(
                                Icons.pause_circle_filled_rounded,
                                color: Colors.white,
                                size: 60,
                              )
                            : const Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        playerProgress();
                        player.seekToNext();
                      },
                      child: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int songLenght = song.length;
RxInt selectedIndex = 0.obs;
RxBool playingState = false.obs;
Rx<Duration> progressValue = const Duration(seconds: 0).obs;
final player = AudioPlayer();
Timer? timer;
List playList = [];

playerProgress() async {
  playListMethode() async {
    for (int i = 0; i <= songLenght; i++) {
      playList.add(song[i].songPath);
      await player.setAsset('song[i].songPath');
    }
  }

  const tick = Duration(seconds: 1);
  int duration = player.duration!.inSeconds;
  player.setAsset('assets/song.mp3');
  if (timer != null) {
    if (timer!.isActive) {
      timer!.cancel();
      timer = null;
    }
  }
  timer = Timer.periodic(tick, (timer) {
    if (player.playing) {
      progressValue.value = player.position;
    }
    if (player.position.inSeconds == duration) {
      timer.cancel();
    }
  });
}
