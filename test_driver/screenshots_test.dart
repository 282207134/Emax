import 'dart:convert';
import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:emax/data/catalog.dart';

void main() {
  late FlutterDriver driver;
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });
  tearDownAll(() async {
    await driver.close();
  });
  test(
    'capture all 34 Pixso screens and verify primary flows on iOS',
    () async {
      Directory('docs/screenshots').createSync(recursive: true);
      final extras = [
        (file: '09_1_bookmarks', path: '/bookmarks', node: ''),
        (file: '09_2_statistics', path: '/statistics', node: ''),
        (file: '09_3_subscriptions', path: '/subscriptions', node: ''),
        (file: '09_4_channels', path: '/channels', node: ''),
        (file: '09_5_notifications', path: '/notifications', node: ''),
      ];
      for (final screen in [...screenCatalog, ...extras]) {
        await driver.requestData(screen.path);
        await driver.waitUntilNoTransientCallbacks();
        if (screen.path == '/onboarding/0') {
          await driver.waitFor(find.text('Many sentence to learn'));
        }
        if (screen.path == '/words/card') {
          await driver.tap(find.byValueKey('answer-2'));
        }
        if (screen.path.startsWith('/quiz/')) {
          await driver.tap(
            find.byValueKey(screen.path == '/quiz/2' ? 'answer-2' : 'answer-0'),
          );
        }
        await Future<void>.delayed(const Duration(milliseconds: 350));
        final result = await Process.run('xcrun', [
          'simctl',
          'io',
          Platform.environment['EMAX_SIMULATOR_ID'] ?? 'booted',
          'screenshot',
          'docs/screenshots/${screen.file}.png',
        ]);
        expect(result.exitCode, 0, reason: result.stderr.toString());
        stdout.writeln('Captured ${screen.file}');
      }
      await driver.requestData('/home');
      for (final index in [1, 2, 3, 4, 0]) {
        await driver.tap(find.byValueKey('tab-$index'));
        await driver.waitUntilNoTransientCallbacks();
      }
      await driver.requestData('/quiz/0');
      for (final answer in [0, 0, 2, 0, 0]) {
        await driver.tap(find.byValueKey('answer-$answer'));
        await driver.tap(find.byValueKey('quiz-next'));
        await driver.waitUntilNoTransientCallbacks();
      }
      await driver.waitFor(find.text('100%'));
      expect(jsonDecode(await driver.requestData(':state'))['bestScore'], 100);
      await driver.requestData('/language');
      await driver.tap(find.byValueKey('language-Chinese'));
      await driver.tap(find.byValueKey('save-language'));
      expect(
        jsonDecode(await driver.requestData(':state'))['language'],
        'Chinese',
      );
      await driver.requestData(':clear');
      await driver.requestData('/words');
      await driver.tap(find.byValueKey('word-parent'));
      await driver.tap(find.byValueKey('answer-2'));
      await driver.tap(find.byValueKey('check-word'));
      expect(
        jsonDecode(await driver.requestData(':state'))['correct'],
        contains('parent'),
      );
      expect(
        await driver.requestData(':tts', timeout: const Duration(seconds: 30)),
        'spoken',
      );
      expect(jsonDecode(await driver.requestData(':errors')), isEmpty);
      await driver.requestData('/home');
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
