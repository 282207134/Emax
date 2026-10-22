import 'package:flutter_tts/flutter_tts.dart';

/// Uses the device's English voice; no recording or remote speech service.
class SpeechPlayer {
  final FlutterTts _engine = FlutterTts();
  int _generation = 0;

  Future<void> speak(String text, {double speed = 1}) async {
    final generation = ++_generation;
    await _engine.stop();
    await _engine.setLanguage('en-US');
    await _engine.setSpeechRate(.45 * speed);
    await _engine.awaitSpeakCompletion(true);
    if (generation == _generation) await _engine.speak(text);
  }

  Future<void> stop() async {
    _generation++;
    try {
      await _engine.stop();
    } catch (_) {
      // A disposed view or a platform without TTS needs no further cleanup.
    }
  }
}
