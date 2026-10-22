import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../../core/speech_player.dart';
import '../../data/catalog.dart';
import '../home/quiz_screen.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      bottomNavigationBar: const BottomTabs(3),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  key: const ValueKey('topics-next'),
                  onPressed: store.selectedTopics.isEmpty
                      ? null
                      : () => go(context, '/words'),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Learn New Word',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Memorize words in more interesting ways.',
                    style: TextStyle(fontSize: 13, color: Color(0xFFA5ADA8)),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pick some topics you want to learn',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: topics.length,
              itemBuilder: (_, i) {
                final topic = topics[i],
                    selected = store.selectedTopics.contains(topic.name);
                return Semantics(
                  button: true,
                  selected: selected,
                  label: '${topic.name}, ${topic.words} words',
                  child: InkWell(
                    key: ValueKey('topic-${topic.name}'),
                    borderRadius: BorderRadius.circular(52),
                    onTap: () => store.toggleTopic(topic.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: selected ? blue : soft,
                        borderRadius: BorderRadius.circular(52),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            topic.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${topic.words} words',
                            style: TextStyle(
                              fontSize: 14,
                              color: selected ? const Color(0xFFD0DFFF) : muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WordBoardScreen extends StatefulWidget {
  const WordBoardScreen({super.key, this.overlay = ''});
  final String overlay;
  @override
  State<WordBoardScreen> createState() => _WordBoardScreenState();
}

class _WordBoardScreenState extends State<WordBoardScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.overlay.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.overlay == 'card') {
          _openCard(vocabulary.first);
        } else {
          _review(widget.overlay == 'correct');
        }
      });
    }
  }

  List<VocabularyCard> _cards(AppStore store) {
    final filtered = vocabulary
        .where((c) => store.selectedTopics.contains(c.topic))
        .toList();
    // Topics without a bundled deck still have an honest empty state.
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context), cards = _cards(store);
    return Scaffold(
      appBar: topBar(
        context,
        '',
        actions: [
          IconButton(
            tooltip: 'How to play',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Learn with word cards'),
                content: const Text(
                  'Tap a card, choose its meaning and check your answer. Wrong answers join your review list. Correct every card to reach the next level.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            ),
            icon: const Icon(CupertinoIcons.question_circle, size: 21),
          ),
        ],
      ),
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.rectangle_stack,
                      size: 48,
                      color: muted,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'This demo includes Family, Finance and Marketing cards.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      'Choose topics',
                      onTap: () => go(context, '/topics'),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 155 / 190,
              ),
              itemCount: cards.length,
              itemBuilder: (_, i) => _cardTile(
                cards[i],
                () => _openCard(cards[i]),
                checked: store.correct.contains(cards[i].word),
              ),
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(
            children: [
              Expanded(
                child: ActionButton(
                  '✓ Correct (${store.correct.length})',
                  key: const ValueKey('correct-list'),
                  color: teal,
                  onTap: () => _review(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  'Wrong (${store.wrong.length})',
                  key: const ValueKey('wrong-list'),
                  color: wine,
                  onTap: () => _review(false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTile(
    VocabularyCard card,
    VoidCallback onTap, {
    bool checked = false,
    bool reveal = false,
  }) => InkWell(
    key: ValueKey('word-${card.word}'),
    borderRadius: BorderRadius.circular(44),
    onTap: onTap,
    child: Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(44),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            bottom: 0,
            child: Picture(
              card.illustration,
              width: 90,
              height: 132,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reveal ? card.word : '${card.topic}\nCard',
                  style: const TextStyle(fontSize: 17),
                ),
                if (reveal) ...[
                  const SizedBox(height: 4),
                  Text(
                    card.options[card.answer],
                    style: const TextStyle(fontSize: 13, color: blue),
                  ),
                ],
              ],
            ),
          ),
          if (checked)
            const Positioned(
              left: 22,
              bottom: 20,
              child: Icon(CupertinoIcons.checkmark_alt, color: blue),
            ),
        ],
      ),
    ),
  );
  Future<void> _openCard(VocabularyCard card) async {
    final right = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => WordQuestion(card),
    );
    if (right == null || !mounted) return;
    final store = AppScope.of(context);
    await store.answerWord(card.word, right);
    if (!mounted) return;
    final cards = _cards(store);
    if (right &&
        cards.isNotEmpty &&
        cards.every((c) => store.correct.contains(c.word))) {
      go(context, '/level-up');
    } else {
      message(
        context,
        right
            ? 'Correct! ${card.word} = ${card.options[card.answer]}'
            : 'Added to review: ${card.word} = ${card.options[card.answer]}',
      );
    }
  }

  void _review(bool right) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        final store = AppScope.of(context),
            words = right ? store.correct : store.wrong;
        final cards = vocabulary.where((c) => words.contains(c.word)).toList();
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${right ? 'Correct' : 'Wrong'} (${cards.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                if (cards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Text(
                      right
                          ? 'Your correct answers will appear here.'
                          : 'No wrong answers yet. Keep practicing!',
                      style: const TextStyle(color: muted),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * .5,
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: cards
                          .map(
                            (c) => _cardTile(
                              c,
                              () {
                                Navigator.pop(context);
                                _openCard(c);
                              },
                              reveal: true,
                              checked: right,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 24),
                ActionButton('Done', onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WordQuestion extends StatefulWidget {
  const WordQuestion(this.card, {super.key});
  final VocabularyCard card;
  @override
  State<WordQuestion> createState() => _WordQuestionState();
}

class _WordQuestionState extends State<WordQuestion> {
  int selected = -1;
  final _speech = SpeechPlayer();
  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.card.topic} Card',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.card.word,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Hear pronunciation',
                  icon: const Icon(CupertinoIcons.speaker_2, color: muted),
                  onPressed: () async {
                    try {
                      await _speech.speak(widget.card.word);
                    } catch (_) {
                      if (context.mounted) {
                        message(
                          context,
                          'English audio is unavailable on this device.',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Tag('noun', color: coral),
                const SizedBox(width: 8),
                Text(
                  widget.card.phonetic,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnswerOption(
                  index: i,
                  label: widget.card.options[i],
                  selected: selected == i,
                  onTap: () => setState(() => selected = i),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ActionButton(
              'Check answer',
              key: const ValueKey('check-word'),
              height: 48,
              onTap: selected < 0
                  ? null
                  : () =>
                        Navigator.pop(context, selected == widget.card.answer),
            ),
          ],
        ),
      ),
    ),
  );
}
