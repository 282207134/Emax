import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../../core/speech_player.dart';
import 'home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, this.mode = ''});
  final String mode;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late bool repeat = widget.mode == 'repeat';
  bool playing = false, liked = false, translated = true;
  double speed = 1;
  final _speech = SpeechPlayer();
  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _play() async {
    if (playing) {
      await _speech.stop();
      if (mounted) setState(() => playing = false);
      return;
    }
    setState(() => playing = true);
    try {
      await _speech.speak(
        widget.mode == 'practice'
            ? 'My arm is broken.'
            : 'No big deal, let’s keep going.',
        speed: speed,
      );
    } catch (_) {
      if (mounted) {
        message(context, 'English audio is unavailable on this device.');
      }
    } finally {
      if (mounted) setState(() => playing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context), practice = widget.mode == 'practice';
    final saved = store.bookmarks.contains('When get hurt');
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                const Picture(
                  'lesson_video',
                  height: 188,
                  width: double.infinity,
                ),
                Positioned.fill(
                  child: Center(
                    child: IconButton(
                      tooltip: 'Play sentence audio',
                      onPressed: _play,
                      icon: Icon(
                        playing
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: blue,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => back(context),
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: 24,
                  bottom: 12,
                  child: InkWell(
                    onTap: () => setState(() => translated = !translated),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        translated ? 'EN / VN' : 'EN',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (playing)
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Text(
                  'Sentence audio • tap pause to stop',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '6 / 12',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _dictionary(context),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: practice ? 'My arm is ' : 'NBD, let’s ',
                          ),
                          TextSpan(
                            text: practice ? 'broken.' : 'keep going.',
                            style: const TextStyle(color: blue),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (translated) ...[
                    const SizedBox(height: 8),
                    Text(
                      practice
                          ? 'Tôi bị gãy tay.'
                          : 'Không có gì to tát cả, tiếp tục nào.',
                      style: const TextStyle(color: muted, fontSize: 14),
                    ),
                  ],
                  if (widget.mode == 'dictionary')
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: coral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Tap a blue word to see it in the dictionary',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 30),
                  const Text(
                    'NBD: (no big deal) không có gì to tát cả.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFBBBFBD)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Dictionary',
                        onPressed: () => _dictionary(context),
                        icon: const Icon(CupertinoIcons.book, color: blue),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(() => repeat = !repeat),
                        child: Text(
                          'Drill',
                          style: TextStyle(color: repeat ? blue : muted),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => speed = speed == 1 ? .75 : 1),
                        child: Text(
                          speed == 1 ? '1x' : '0.75',
                          style: const TextStyle(color: ink),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Repeat sentence',
                        onPressed: () => setState(() => repeat = !repeat),
                        icon: Icon(
                          CupertinoIcons.repeat,
                          color: repeat ? blue : muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Chỉ xước nhẹ thôi ý mà.',
                style: TextStyle(color: muted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _action(
                  CupertinoIcons.hand_thumbsup,
                  liked ? '63' : '62',
                  () => setState(() => liked = !liked),
                  liked,
                ),
                _action(
                  CupertinoIcons.bubble_left,
                  '3',
                  () => showModalBottomSheet(
                    context: context,
                    builder: (_) => const Padding(
                      padding: EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Ellen: Keep practicing, you’re doing great!'),
                          SizedBox(height: 16),
                          Text('Charlie: This is a useful everyday sentence.'),
                          SizedBox(height: 16),
                          Text('Harriett: Added to my bookmarks!'),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  false,
                ),
                _action(
                  saved
                      ? CupertinoIcons.bookmark_fill
                      : CupertinoIcons.bookmark,
                  'Bookmark',
                  () => store.toggleBookmark('When get hurt'),
                  saved,
                ),
                _action(CupertinoIcons.share, 'Share', () async {
                  await Clipboard.setData(
                    const ClipboardData(
                      text: 'Emax • When get hurt: It’s just a scratch.',
                    ),
                  );
                  if (context.mounted) {
                    message(context, 'Lesson summary copied');
                  }
                }, false),
                _action(
                  CupertinoIcons.ellipsis,
                  'More',
                  () => showModalBottomSheet(
                    context: context,
                    builder: (_) => SafeArea(
                      child: ListTile(
                        title: const Text('Start memory test'),
                        leading: const Icon(CupertinoIcons.checkmark_seal),
                        onTap: () {
                          Navigator.pop(context);
                          go(context, '/quiz/0');
                        },
                      ),
                    ),
                  ),
                  false,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PersonRow(
                'Ellen Jacobs',
                'ellen',
                subtitle: '3.7k subscribers',
                size: 40,
                trailing: TextButton(
                  onPressed: () => store.toggleSubscription('Ellen Jacobs'),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        store.subscriptions.contains('Ellen Jacobs')
                        ? soft
                        : blue,
                    foregroundColor:
                        store.subscriptions.contains('Ellen Jacobs')
                        ? muted
                        : Colors.white,
                  ),
                  child: Text(
                    store.subscriptions.contains('Ellen Jacobs')
                        ? '✓ Subscribed'
                        : 'Subscribe',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Practice Speaking !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    practice ? 'My arm is broken.' : 'It’s just a scratch.',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chỉ xước nhẹ thôi ý mà.',
                    style: TextStyle(color: Color(0xFFB8BBC7)),
                  ),
                  const SizedBox(height: 24),
                  ActionButton(
                    'Read the form',
                    color: Colors.white,
                    foreground: blue,
                    onTap: () => go(context, '/speaking'),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Let’s practice speaking !',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            if (repeat)
              Container(
                color: green,
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: Text(
                    'This sentence will be repeated',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SectionTitle('When get hurt'),
                  const SizedBox(height: 16),
                  const SentenceList(),
                  const SizedBox(height: 20),
                  const SectionTitle('Memory Test'),
                  const SizedBox(height: 24),
                  ActionButton(
                    'Go to test',
                    key: const ValueKey('go-test'),
                    onTap: () => go(context, '/quiz/0'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(
    IconData icon,
    String label,
    VoidCallback onTap,
    bool active,
  ) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Icon(icon, color: active ? blue : muted, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: active ? blue : muted),
          ),
        ],
      ),
    ),
  );
  void _dictionary(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'keep going',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
            ),
            SizedBox(height: 8),
            Text('/kiːp ˈɡəʊ.ɪŋ/  •  phrase', style: TextStyle(color: muted)),
            SizedBox(height: 24),
            Text('Continue doing something, even when it is difficult.'),
            SizedBox(height: 12),
            Text('tiếp tục, không bỏ cuộc', style: TextStyle(color: blue)),
            SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
