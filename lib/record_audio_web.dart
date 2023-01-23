import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RecordAudioWeb extends StatefulWidget {
  const RecordAudioWeb({Key? key}) : super(key: key);

  @override
  State<RecordAudioWeb> createState() => _RecordAudioWebState();
}

class _RecordAudioWebState extends State<RecordAudioWeb> {
  int recordDuration = 0;
  Timer? timer;
  String text = '---';
  Record audioRecorder = Record();
  StreamSubscription<RecordState>? recordSub;
  RecordState recordState = RecordState.stop;
  StreamSubscription<Amplitude>? amplitudeSub;
  Amplitude? amplitude;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    recordSub = audioRecorder.onStateChanged().listen((recordStateInner) {
      setState(() {
        recordState = recordStateInner;
      });
    });

    amplitudeSub = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
          setState(() {
            amplitude = amp;
          });
        });
    super.initState();
  }

  @override
  void dispose() {
     timer?.cancel();
     recordSub?.cancel();
     amplitudeSub?.cancel();
     audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('record audio web'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              amplitude != null ? Text('amplitude ${amplitude!.current}') : const Text('amplitude null'),
              Text('recordState $recordState'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (await audioRecorder.hasPermission()) {
                    setState(() {
                      text = 'recording audio...';
                    });
                    await audioRecorder.start(
                      path: 'storage/emulated/0/Download/myAudio.mp3',
                      encoder: AudioEncoder.aacLc, // by default
                      bitRate: 128000, // by default
                      samplingRate: 44100, // by default
                    );
                    debugPrint('started');
                  }
                },
                child: const Text('Start Recording Audio'),
              ),

              OutlinedButton(
                onPressed: () async {
                  await audioRecorder.stop();
                  setState(() {
                    text = 'Stopped recording';
                  });
                  debugPrint('stopped');
                },
                child: const Text('Stop Recording Audio'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    text = 'playing audio....';
                  });
                  await assetsAudioPlayer.open(
                    Audio.file('storage/emulated/0/Download/myAudio.mp3'),
                  );
                  debugPrint('Played audio...');
                },
                child: const Text('audio Play'),
              ),
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    text = 'stopped audio!';
                  });
                  await assetsAudioPlayer.stop();
                  debugPrint('stopped audio');
                },
                child: const Text('audio stop'),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () async {
              setState(() {
                text = 'assetsAudioPlayer: ${assetsAudioPlayer.id}';
              });
            },
            child: const Text('print'),
          )
        ],
      ),
    );
  }
}
