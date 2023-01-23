import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioFingerPrint extends StatefulWidget {
  const AudioFingerPrint({Key? key}) : super(key: key);

  @override
  State<AudioFingerPrint> createState() => _AudioFingerPrintState();
}

class _AudioFingerPrintState extends State<AudioFingerPrint> {
  List<FileSystemEntity> songs = [];
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();


  void pickAudioSongFromInternal() {
    Directory dir = Directory('/storage/emulated/0/Download');
    List<FileSystemEntity> files;
    files = dir.listSync(recursive: true, followLinks: false);
    for(FileSystemEntity entity in files) {
      String path = entity.path;
      if(path.endsWith('.mp3')) {
        songs.add(entity);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio FingerPrint'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {
                pickAudioSongFromInternal();
              },
              child: const Text('Fetch Songs'),
            ),
            songs.isNotEmpty ?
            Column(
              mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        if (!(assetsAudioPlayer.isPlaying.value)) {
                          assetsAudioPlayer.open(
                            Audio.file(songs[0].path),
                          );
                        }

                        // await assetsAudioPlayer.play();
                      },
                      child: const Text('play'),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await assetsAudioPlayer.stop();
                      },
                      child: const Text('Stop'),
                    ),
                  ],
                ),
                assetsAudioPlayer.builderCurrent(builder: (context, playing) {
                  return Container(
                    height: 100,
                    width: 200,
                    color: Colors.red,
                    child: const Center(
                      child: Text('playing song'),
                    ),
                  );
                },),
                OutlinedButton(
                  onPressed: () {

                  },
                  child: const Text('Generate FingerPrints'),
                ),
              ],
            )
                :
            const SizedBox(height: 0,width: 0,),
          ],
        ),
      ),
    );
  }
}