import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  double? frequency;
  String? note;
  int? octave;
  bool? isRecording;

  FlutterFft flutterFft = FlutterFft();

  _initialize() async {
    debugPrint("Starting recorder...");
    // print("Before");
    // bool hasPermission = await flutterFft.checkPermission();
    // print("After: " + hasPermission.toString());

    // Keep asking for mic permission until accepted
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    // await flutterFft.checkPermissions();
    await flutterFft.startRecorder();
    debugPrint("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);

    flutterFft.onRecorderStateChanged.listen(
            (data) => {
          debugPrint("Changed state, received: $data"),
          setState(
                () => {
              frequency = data[1] as double,
              note = data[2] as String,
              octave = data[5] as int,
            },
          ),
          flutterFft.setNote = note!,
          flutterFft.setFrequency = frequency!,
          flutterFft.setOctave = octave!,
          debugPrint("Octave: ${octave!.toString()}")
        },
        onError: (err) {
          debugPrint("Error: $err");
        },
        onDone: () => {debugPrint("Is done")});
  }

  @override
  void initState() {
    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    note = flutterFft.getNote;
    octave = flutterFft.getOctave;
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isRecording!
                ? Text("Current note: ${note!},${octave!.toString()}",
                style: const TextStyle(fontSize: 30))
                : const Text("Not Recording", style: TextStyle(fontSize: 35)),
            isRecording!
                ? Text(
                "Current frequency: ${frequency!.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 30))
                : const Text("Not Recording", style: TextStyle(fontSize: 35))
          ],
        ),
      ),
    );
  }
}

