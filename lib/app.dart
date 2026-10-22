import 'package:flutter/material.dart';
import 'core/app_store.dart';
import 'core/ui.dart';
import 'features/auth/auth_screens.dart';
import 'features/home/home_screen.dart';
import 'features/home/post_screen.dart';
import 'features/home/quiz_screen.dart';
import 'features/search/search_screens.dart';
import 'features/speaking/speaking_screens.dart';
import 'features/vocabulary/vocabulary_screens.dart';
import 'features/profile/profile_screens.dart';

class EmaxApp extends StatelessWidget {
  const EmaxApp({
    super.key,
    required this.store,
    this.navigatorKey,
    this.initialRoute = '/splash',
  });
  final AppStore store;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String initialRoute;
  @override
  Widget build(BuildContext context) => AppScope(
    store: store,
    child: MaterialApp(
      title: 'Emax',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Nunito',
          bodyColor: ink,
          displayColor: ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(color: soft),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: muted, fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: soft),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: blue),
          ),
        ),
      ),
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
      onGenerateRoute: _route,
    ),
  );
  Route<dynamic> _route(RouteSettings settings) => MaterialPageRoute<void>(
    settings: settings,
    builder: (context) {
      final path = Uri.parse(settings.name ?? '/home').pathSegments;
      final section = path.isEmpty ? 'home' : path.first;
      final detail = path.length > 1 ? path[1] : '';
      return switch (section) {
        'splash' => const SplashScreen(),
        'onboarding' => OnboardingScreen(int.tryParse(detail) ?? 0),
        'signup' => const AuthScreen(signUp: true),
        'signin' => const AuthScreen(),
        'home' => const HomeScreen(),
        'post' => PostScreen(mode: detail),
        'quiz' => QuizScreen(start: int.tryParse(detail) ?? 0),
        'search' => const SearchScreen(),
        'category' => CategoryScreen(detail),
        'channel' => const ChannelScreen(),
        'speak' => const SpeakingScreen(),
        'course' => const CourseScreen(),
        'conversation' ||
        'listen' ||
        'speaking' => ConversationScreen(mode: section),
        'result' => ResultScreen(
          speaking: detail == 'speaking',
          score: path.length > 2 ? int.tryParse(path[2]) ?? 100 : 100,
        ),
        'level-up' => const ResultScreen(levelUp: true),
        'topics' => const TopicsScreen(),
        'words' => WordBoardScreen(overlay: detail),
        'profile' => const ProfileScreen(),
        'language' => const LanguageScreen(),
        'bookmarks' ||
        'statistics' ||
        'subscriptions' ||
        'channels' ||
        'notifications' => ProfileDetailScreen(section),
        _ => const HomeScreen(),
      };
    },
  );
}
