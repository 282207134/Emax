import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.preferences) {
    onboarded = preferences.getBool('onboarded') ?? false;
    language = preferences.getString('language') ?? 'Tiếng Việt';
    selectedTopics =
        (preferences.getStringList('topics') ??
                ['Family', 'Finance', 'Marketing'])
            .toSet();
    bookmarks = (preferences.getStringList('bookmarks') ?? []).toSet();
    subscriptions = (preferences.getStringList('subscriptions') ?? []).toSet();
    correct = (preferences.getStringList('correct') ?? []).toSet();
    wrong = (preferences.getStringList('wrong') ?? []).toSet();
    completedLessons = (preferences.getStringList('lessons') ?? []).toSet();
    bestScore = preferences.getInt('bestScore') ?? 0;
  }
  final SharedPreferences preferences;
  late bool onboarded;
  late String language;
  late Set<String> selectedTopics,
      bookmarks,
      subscriptions,
      correct,
      wrong,
      completedLessons;
  late int bestScore;

  Future<void> finishOnboarding() async {
    onboarded = true;
    notifyListeners();
    await preferences.setBool('onboarded', true);
  }

  Future<void> setLanguage(String value) async {
    language = value;
    notifyListeners();
    await preferences.setString('language', value);
  }

  Future<void> toggleTopic(String topic) =>
      _toggle(selectedTopics, topic, 'topics');
  Future<void> toggleBookmark(String sentence) =>
      _toggle(bookmarks, sentence, 'bookmarks');
  Future<void> toggleSubscription(String name) =>
      _toggle(subscriptions, name, 'subscriptions');
  Future<void> _toggle(Set<String> values, String value, String key) async {
    if (!values.add(value)) values.remove(value);
    notifyListeners();
    await preferences.setStringList(key, values.toList());
  }

  Future<void> answerWord(String word, bool right) async {
    (right ? correct : wrong).add(word);
    (right ? wrong : correct).remove(word);
    notifyListeners();
    await preferences.setStringList('correct', correct.toList());
    await preferences.setStringList('wrong', wrong.toList());
  }

  Future<void> completeLesson(String lesson) async {
    completedLessons.add(lesson);
    notifyListeners();
    await preferences.setStringList('lessons', completedLessons.toList());
  }

  Future<void> saveScore(int value) async {
    if (value <= bestScore) return;
    bestScore = value;
    notifyListeners();
    await preferences.setInt('bestScore', value);
  }
}

class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
