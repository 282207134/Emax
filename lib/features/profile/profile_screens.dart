import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../home/home_screen.dart';
import '../search/search_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      backgroundColor: soft,
      bottomNavigationBar: const BottomTabs(4),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            SizedBox(
              height: 278,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: Confetti())),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Picture('profile', width: 96, height: 96, radius: 32),
                        SizedBox(height: 22),
                        Text(
                          'Harriett Knight',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Beginner',
                          style: TextStyle(fontSize: 16, color: muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
              child: Column(
                children: [
                  _row(
                    context,
                    'Native language',
                    CupertinoIcons.globe,
                    dark,
                    '/language',
                    subtitle: store.language,
                  ),
                  _row(
                    context,
                    'Bookmark list',
                    CupertinoIcons.bookmark,
                    const Color(0xFF00AEEF),
                    '/bookmarks',
                  ),
                  _row(
                    context,
                    'My statistic',
                    CupertinoIcons.chart_bar,
                    teal,
                    '/statistics',
                  ),
                  _row(
                    context,
                    'Subscribed channel',
                    CupertinoIcons.tv,
                    const Color(0xFFFF3C72),
                    '/subscriptions',
                  ),
                  _row(
                    context,
                    'Word topic change',
                    CupertinoIcons.square_grid_2x2,
                    green,
                    '/topics',
                  ),
                  TextButton(
                    onPressed: () => go(context, '/onboarding/0'),
                    child: const Text(
                      'Replay introduction',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route, {
    String? subtitle,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: InkWell(
      onTap: () => go(context, route),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: muted, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          ArrowButton(onTap: () => go(context, route)),
        ],
      ),
    ),
  );
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selected;
  static const languages = [
    'Tiếng Việt',
    'Korea',
    'Chinese',
    'George',
    'Albania',
    'Polish',
    'Persian',
    'Belarus',
    'Bengal',
    'Portuguese',
  ];
  @override
  Widget build(BuildContext context) {
    final value = selected ?? AppScope.of(context).language;
    return Scaffold(
      backgroundColor: soft,
      appBar: topBar(context, 'Native language', background: soft),
      body: ListView(
        children: languages
            .map(
              (s) => ListTile(
                key: ValueKey('language-$s'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                minTileHeight: 60,
                title: Text(
                  s,
                  style: TextStyle(
                    fontSize: 16,
                    color: value == s ? blue : ink,
                  ),
                ),
                tileColor: value == s ? const Color(0xFFDCE4F8) : null,
                trailing: value == s
                    ? const Icon(CupertinoIcons.checkmark_alt, color: blue)
                    : null,
                onTap: () => setState(() => selected = s),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
          child: ActionButton(
            'Save',
            key: const ValueKey('save-language'),
            onTap: () async {
              await AppScope.of(context).setLanguage(value);
              if (context.mounted) {
                back(context);
                message(context, 'Native language saved');
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen(this.type, {super.key});
  final String type;
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final title = {
      'bookmarks': 'Bookmark list',
      'statistics': 'My statistic',
      'subscriptions': 'Subscribed channel',
      'channels': 'Channels',
      'notifications': 'Notifications',
    }[type]!;
    return Scaffold(
      appBar: topBar(context, title),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (type == 'statistics') ...[
            const SectionTitle('Your learning journey'),
            const SizedBox(height: 24),
            _stat('Best memory test', '${store.bestScore}%'),
            _stat('Completed lessons', '${store.completedLessons.length}'),
            _stat('Words learned', '${store.correct.length}'),
            _stat('Words to review', '${store.wrong.length}'),
            _stat('Selected topics', '${store.selectedTopics.length}'),
          ] else if (type == 'channels')
            const ChannelList()
          else if (type == 'bookmarks') ...[
            if (store.bookmarks.isEmpty)
              _empty('Save a lesson with Bookmark to find it here.')
            else ...[
              const SectionTitle('When get hurt'),
              const SizedBox(height: 24),
              const SentenceList(),
            ],
          ] else if (type == 'subscriptions') ...[
            if (store.subscriptions.isEmpty)
              _empty(
                'Follow a channel to keep learning with your favorite teachers.',
              ),
            ...store.subscriptions.map(
              (name) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PersonRow(
                  name,
                  name == 'Ellen Jacobs' ? 'ellen' : 'cornelia',
                  subtitle: 'Subscribed',
                  onTap: () => go(context, '/channel'),
                ),
              ),
            ),
          ] else ...[
            _notification(
              'Continue your learning',
              'Practice a few words today.',
              '/topics',
              context,
            ),
            _notification(
              'English REAL TALK',
              'Your next conversation is ready.',
              '/course',
              context,
            ),
            _notification(
              'Memory test',
              'See how many sentences you remember.',
              '/quiz/0',
              context,
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: soft,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(
          value,
          style: const TextStyle(
            color: blue,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
  Widget _empty(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 80),
    child: Column(
      children: [
        const Icon(CupertinoIcons.rectangle_stack, size: 48, color: muted),
        const SizedBox(height: 20),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: muted, fontSize: 16),
        ),
      ],
    ),
  );
  Widget _notification(
    String title,
    String subtitle,
    String route,
    BuildContext context,
  ) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    leading: const Icon(CupertinoIcons.bell, color: blue),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
    onTap: () => go(context, route),
  );
}
