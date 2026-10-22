import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emax/app.dart';
import 'package:emax/core/app_store.dart';
import 'package:emax/core/speech_player.dart';

Future<void> main() async {
  final navigator = GlobalKey<NavigatorState>();
  late AppStore store;
  final errors = <String>[];
  enableFlutterDriverExtension(
    handler: (command) async {
      if (command == ':tts') {
        final speech = SpeechPlayer();
        await speech.speak('Welcome to Emax.');
        await speech.stop();
        return 'spoken';
      }
      if (command == ':errors') return jsonEncode(errors);
      if (command == ':state') {
        return jsonEncode({
          'language': store.language,
          'correct': store.correct.toList(),
          'wrong': store.wrong.toList(),
          'bestScore': store.bestScore,
        });
      }
      if (command == ':clear') {
        store.correct.clear();
        store.wrong.clear();
        return 'cleared';
      }
      navigator.currentState!.pushNamedAndRemoveUntil(
        command ?? '/home',
        (_) => false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return command ?? '';
    },
  );
  FlutterError.onError = (details) {
    errors.add(details.exceptionAsString());
    FlutterError.presentError(details);
  };
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SharedPreferences.setMockInitialValues({
    'onboarded': true,
    'correct': <String>['parent', 'analyse'],
    'wrong': <String>['contract', 'initiator'],
    'lessons': <String>['Go buy shoes', 'Asking for Directions'],
  });
  store = AppStore(await SharedPreferences.getInstance());
  runApp(EmaxApp(store: store, navigatorKey: navigator, initialRoute: '/home'));
}
