import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emax/app.dart';
import 'package:emax/core/app_store.dart';
import 'package:emax/data/catalog.dart';

Future<AppStore> freshStore([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return AppStore(await SharedPreferences.getInstance());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Nunito')
      ..addFont(rootBundle.load('assets/fonts/Nunito.ttf'));
    await font.load();
  });
  test(
    'preferences restore topic, bookmark, language, score and word corrections',
    () async {
      final store = await freshStore();
      await store.toggleTopic('Business');
      await store.toggleBookmark('When get hurt');
      await store.toggleSubscription('Cornelia Gordon');
      await store.setLanguage('Chinese');
      await store.answerWord('parent', false);
      await store.answerWord('parent', true);
      await store.completeLesson('When taking a taxi');
      await store.saveScore(100);
      await store.saveScore(60);
      final restored = AppStore(await SharedPreferences.getInstance());
      expect(restored.selectedTopics, contains('Business'));
      expect(restored.bookmarks, contains('When get hurt'));
      expect(restored.subscriptions, contains('Cornelia Gordon'));
      expect(restored.language, 'Chinese');
      expect(restored.correct, {'parent'});
      expect(restored.wrong, isEmpty);
      expect(restored.bestScore, 100);
      expect(restored.completedLessons, contains('When taking a taxi'));
    },
  );

  testWidgets('leaving splash during its timer cannot replace the next page', (
    tester,
  ) async {
    final store = await freshStore({'onboarded': true});
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(EmaxApp(store: store, navigatorKey: navigator));
    await tester.pump(const Duration(milliseconds: 1450));
    navigator.currentState!.pushNamedAndRemoveUntil(
      '/onboarding/0',
      (_) => false,
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Many sentence to learn'), findsOneWidget);
    expect(find.text('Hi, Steven !'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('home carousel keeps its page across state updates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = await freshStore();
    await tester.pumpWidget(EmaxApp(store: store, initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(
      tester.widget<PageView>(find.byType(PageView)).controller!.page,
      closeTo(1, .01),
    );
    await store.toggleBookmark('When get hurt');
    await tester.pumpAndSettle();
    expect(
      tester.widget<PageView>(find.byType(PageView)).controller!.page,
      closeTo(1, .01),
    );
  });

  for (final screen in screenCatalog) {
    testWidgets('renders ${screen.file} without overflow or missing assets', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = await freshStore({
        'correct': <String>['parent', 'analyse'],
        'wrong': <String>['contract', 'initiator'],
      });
      await tester.pumpWidget(EmaxApp(store: store, initialRoute: screen.path));
      await tester.pump();
      if (screen.path == '/splash') {
        await tester.pump(const Duration(milliseconds: 300));
      } else {
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  }

  testWidgets('quiz computes a real score and persists it', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = await freshStore();
    await tester.pumpWidget(EmaxApp(store: store, initialRoute: '/quiz/0'));
    await tester.pumpAndSettle();
    for (final answer in [0, 0, 2, 0, 0]) {
      await tester.tap(find.byKey(ValueKey('answer-$answer')).first);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('quiz-next')));
      await tester.pumpAndSettle();
    }
    expect(find.text('100%'), findsOneWidget);
    expect(store.bestScore, 100);
    expect(tester.takeException(), isNull);
  });

  testWidgets('word card moves wrong answers into correct after retry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = await freshStore();
    await tester.pumpWidget(EmaxApp(store: store, initialRoute: '/words'));
    await tester.pumpAndSettle();
    for (final answer in [0, 2]) {
      await tester.tap(find.byKey(const ValueKey('word-parent')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('answer-$answer')).first);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('check-word')));
      await tester.pumpAndSettle();
    }
    expect(store.correct, contains('parent'));
    expect(store.wrong, isNot(contains('parent')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('sign in validates fields before allowing entry', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = await freshStore();
    await tester.pumpWidget(EmaxApp(store: store, initialRoute: '/signin'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('auth-submit')));
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Use at least 6 characters'), findsOneWidget);
    expect(store.onboarded, isFalse);
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'demo123',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('auth-submit')));
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    expect(store.onboarded, isTrue);
    expect(find.text('Hi, Steven !'), findsOneWidget);
  });
}
