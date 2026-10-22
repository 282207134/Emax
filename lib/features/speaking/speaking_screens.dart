import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../../core/speech_player.dart';
import '../../data/catalog.dart';

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});
  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  String filter = 'All';
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: const BottomTabs(2),
    body: SafeArea(
      bottom: false,
      child: ListView(
        children: [
          const PageHeading(
            'Speaking Course',
            'Improve your speak skill with many courses',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Studying Course'),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Picture('course', height: 215, radius: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Tag('Intermediate'),
                          const SizedBox(height: 8),
                          const Text(
                            'English REAL TALK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Is speak English as easy but rigid as a textbook? No no!! You’re wrong! ...',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: muted,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ArrowButton(
                            wide: true,
                            onTap: () => go(context, '/course'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                const SectionTitle('Courses'),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: FilterPills(
              const ['All', 'Beginner', 'Intermediate', 'Advanced'],
              filter,
              (v) => setState(() => filter = v),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                if (filter == 'All' || filter == 'Beginner') ...[
                  _course(
                    context,
                    'Basic communication English',
                    'globe',
                    '12 Lessons',
                  ),
                  _course(
                    context,
                    'Essential Structures',
                    'architecture',
                    '6 Lessons',
                  ),
                ],
                if (filter == 'Intermediate')
                  _course(
                    context,
                    'English REAL TALK',
                    'course',
                    '10 Lessons',
                    level: 'Intermediate',
                  ),
                if (filter == 'Advanced')
                  _course(
                    context,
                    'Confident conversations',
                    'travel',
                    '8 Lessons',
                    level: 'Advanced',
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _course(
    BuildContext context,
    String title,
    String image,
    String lessons, {
    String level = 'Primary',
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      children: [
        Picture(image, width: 82, height: 106, radius: 16),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Tag(level, color: coral),
                  const SizedBox(width: 12),
                  Text(
                    lessons,
                    style: const TextStyle(fontSize: 14, color: muted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ArrowButton(wide: true, onTap: () => go(context, '/course')),
            ],
          ),
        ),
      ],
    ),
  );
}

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      backgroundColor: teal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: teal,
            foregroundColor: Colors.white,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => back(context),
              icon: const Icon(CupertinoIcons.arrow_left),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              background: Picture('course'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'English REAL TALK',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Tag('Intermediate'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Is speak English as easy but rigid as a textbook? No no!! You’re wrong!\nLearning REAL TALK, meet real-life natives on podcasts to get awesome at English!',
                    style: TextStyle(
                      color: Color(0xFFB4D4E5),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lesson (10)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(10, (i) {
                    final done = store.completedLessons.contains(
                      lessonTitles[i],
                    );
                    return InkWell(
                      key: ValueKey('lesson-$i'),
                      onTap: () => go(context, '/conversation'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: done ? blue : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: done
                                  ? const Icon(
                                      CupertinoIcons.checkmark,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${i + 1}',
                                      style: const TextStyle(color: muted),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lessonTitles[i],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    lessonSubtitles[i % 4],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: done ? Colors.white : blue,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: blue.withValues(alpha: .4),
                                ),
                              ),
                              child: Text(
                                done ? 'Relearn' : 'Learn',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: done ? blue : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, this.mode = 'conversation'});
  final String mode;
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool subtitles = true;
  final Set<int> playing = {};
  int practiceStep = 0;
  final _speech = SpeechPlayer();
  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _playLine(int i) async {
    final wasPlaying = playing.contains(i);
    setState(() {
      playing.clear();
      if (!wasPlaying) playing.add(i);
    });
    try {
      if (wasPlaying) {
        await _speech.stop();
      } else {
        await _speech.speak(conversation[i].$1);
      }
    } catch (_) {
      if (mounted) {
        message(context, 'English audio is unavailable on this device.');
      }
    } finally {
      if (mounted) setState(() => playing.remove(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.mode == 'conversation',
        speaking = widget.mode == 'speaking';
    return Scaffold(
      backgroundColor: chat ? dark : soft,
      extendBodyBehindAppBar: chat,
      appBar: topBar(
        context,
        chat
            ? 'When taking a taxi'
            : speaking
            ? 'Speaking'
            : 'Listen',
        background: chat ? Colors.transparent : soft,
        foreground: chat ? Colors.white : ink,
        actions: [
          if (widget.mode == 'listen')
            TextButton(
              onPressed: () => setState(() => subtitles = !subtitles),
              child: Text(
                subtitles ? 'Subtitle' : 'EN only',
                style: const TextStyle(color: ink),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (chat) ...[
            const Positioned.fill(child: Picture('course')),
            Positioned.fill(
              child: ColoredBox(color: dark.withValues(alpha: .7)),
            ),
          ],
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                chat ? 16 : 24,
                24,
                chat ? 16 : 24,
                120,
              ),
              children: [
                if (speaking)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Practice demo · tap the mic to advance',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ...List.generate(speaking ? 3 : conversation.length, (i) {
                  final line = conversation[i],
                      active =
                          playing.contains(i) ||
                          (speaking && i == practiceStep);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: active
                          ? blue
                          : chat || speaking
                          ? Colors.white
                          : soft,
                      borderRadius: BorderRadius.circular(30),
                      border: chat || speaking
                          ? null
                          : Border.all(color: const Color(0xFFB0B0B4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                line.$1,
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.5,
                                  color: active ? Colors.white : ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (speaking)
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: i < practiceStep ? 1 : .8,
                                      color: active ? Colors.white : blue,
                                      strokeWidth: 1,
                                    ),
                                    Text(
                                      i < practiceStep
                                          ? '100'
                                          : i == 0
                                          ? '80'
                                          : '90',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: active ? Colors.white : blue,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              IconButton(
                                tooltip: 'Preview sentence',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _playLine(i),
                                icon: Icon(
                                  chat
                                      ? CupertinoIcons.speaker_2
                                      : active
                                      ? CupertinoIcons.pause_fill
                                      : CupertinoIcons.play_fill,
                                  color: active ? Colors.white : muted,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        if (subtitles && !speaking) ...[
                          const SizedBox(height: 8),
                          Text(
                            line.$2,
                            style: TextStyle(
                              color: active ? const Color(0xFFCFDFFF) : muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (chat || speaking) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (chat)
                                SizedBox(
                                  width: 160,
                                  child: ActionButton(
                                    'Repeat',
                                    icon: CupertinoIcons.mic,
                                    height: 40,
                                    color: teal,
                                    onTap: () => go(context, '/speaking'),
                                  ),
                                ),
                              const Spacer(),
                              Text(
                                line.$3,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: active ? Colors.white : ink,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Picture(
                                i.isEven ? 'ellen' : 'charlie',
                                width: 24,
                                height: 24,
                                radius: 12,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                if (!speaking)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ActionButton(
                      'Practice speaking',
                      onTap: () => go(context, '/speaking'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: speaking
              ? Center(
                  heightFactor: 1,
                  child: IconButton.filled(
                    key: const ValueKey('practice-mic'),
                    tooltip: 'Practice next sentence (demo)',
                    style: IconButton.styleFrom(
                      backgroundColor: wine,
                      minimumSize: const Size(58, 58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () async {
                      if (practiceStep < 2) {
                        setState(() => practiceStep++);
                      } else {
                        await AppScope.of(
                          context,
                        ).completeLesson('When taking a taxi');
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/result/speaking/100');
                        }
                      }
                    },
                    icon: const Icon(CupertinoIcons.mic, size: 24),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        'Listen',
                        color: green,
                        onTap: () => go(context, '/listen'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        'Speaking',
                        icon: CupertinoIcons.mic,
                        onTap: () => go(context, '/speaking'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    this.speaking = false,
    this.score = 100,
    this.levelUp = false,
  });
  final bool speaking, levelUp;
  final int score;
  @override
  Widget build(BuildContext context) {
    final perfect = score == 100 || levelUp;
    final title = levelUp
        ? 'Congratulation!'
        : speaking
        ? perfect
              ? 'Perfect speaking!'
              : 'You speak is good!'
        : perfect
        ? 'You are awesome!'
        : 'Don’t Give Up!';
    final subtitle = levelUp
        ? 'You have answered all the cards correctly and up to the new level'
        : speaking
        ? perfect
              ? 'Congratulations for speaking all the sentence perfect!'
              : 'Practice speaking more and pronounce correctly!'
        : perfect
        ? 'Congratulations for getting all the answers correct!'
        : 'Study more next time and get all the answers correct!';
    return Scaffold(
      backgroundColor: soft,
      appBar: topBar(context, '', close: true, background: soft),
      body: Stack(
        children: [
          if (perfect) Positioned.fill(child: CustomPaint(painter: Confetti())),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            if (levelUp)
                              const Picture(
                                'level_up',
                                width: 262,
                                height: 241,
                                fit: BoxFit.contain,
                              )
                            else
                              SizedBox(
                                width: 188,
                                height: 188,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 162,
                                      height: 162,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value: score / 100,
                                        strokeWidth: 10,
                                        backgroundColor: const Color(
                                          0xFFD7D7DA,
                                        ),
                                        color: perfect
                                            ? blue
                                            : speaking
                                            ? teal
                                            : green,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    Container(
                                      width: 148,
                                      height: 148,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFE5E5E8),
                                          width: 8,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$score%',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w800,
                                            color: perfect
                                                ? blue
                                                : speaking
                                                ? teal
                                                : green,
                                          ),
                                        ),
                                        Text(
                                          speaking
                                              ? perfect
                                                    ? 'Perfect'
                                                    : 'Good'
                                              : '${(score * 5 / 100).round()} of 5',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 52),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
                  child: ActionButton(
                    levelUp
                        ? 'Continue'
                        : perfect
                        ? 'Done'
                        : 'Retry',
                    key: const ValueKey('result-action'),
                    onTap: () {
                      if (perfect) {
                        home(context);
                      } else {
                        Navigator.of(context).pushReplacementNamed(
                          speaking ? '/speaking' : '/quiz/0',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
