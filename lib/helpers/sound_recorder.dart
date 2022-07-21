
// import 'package:flutter_sound/flutter_sound.dart';

// class SoundRecorder {
//   FlutterSoundRecorder? _audioRecorder;
//   final audioFilePath = 'audio.aac';

//   Future init() async {
//     _audioRecorder = FlutterSoundRecorder();



//     await _audioRecorder!.openAudioSession();
//   }

//   void dispose() async {
//      _audioRecorder!.closeAudioSession();
// _audioRecorder = null;

//   }

//   Future _record() async {
//     await _audioRecorder!.startRecorder(toFile: audioFilePath);
//   }

//   Future _stop() async {
//     await _audioRecorder!.stopRecorder();
//   }

//   Future toggleRecording() async {
//     if (_audioRecorder!.isStopped) {
//       await _record();
//     } else {
//       await _stop();
//     }
//   }

// }
