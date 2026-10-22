import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.start = 0});
  final int start;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late int question = widget.start;
  int selected = -1, correct = 0, remaining = 60;
  Timer? _timer;
  bool _leaving = false;
  static const total = 5;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 1) {
        _timer?.cancel();
        _finish();
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_leaving || !mounted) return;
    _leaving = true;
    _timer?.cancel();
    final score = (correct / total * 100).round();
    await AppScope.of(context).saveScore(score);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/result/test/$score');
    }
  }

  void _next() {
    if (selected == (question % 3 == 2 ? 2 : 0)) correct++;
    if (question == total - 1) {
      _finish();
    } else {
      setState(() {
        question++;
        selected = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = question % 3;
    return Scaffold(
      backgroundColor: type == 0 ? blue : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Exit test',
                    onPressed: () => back(context),
                    icon: Icon(
                      CupertinoIcons.xmark,
                      color: type == 0 ? Colors.white : ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: remaining / 60,
                        minHeight: 20,
                        backgroundColor: const Color(0xFFB4CEFF),
                        color: type == 0 ? Colors.white : blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$remaining',
                    style: TextStyle(
                      color: type == 0 ? Colors.white : blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: type == 0 ? Colors.white : null,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  children: [
                    if (type == 0)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${question + 1} of $total',
                              style: const TextStyle(
                                color: Color(0xFFC2D8FF),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'I ┄┄┄┄ my knee.',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tôi bị xước đầu gối.',
                              style: TextStyle(
                                color: Color(0xFFCFDFFF),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Center(
                        child: Text(
                          '${question + 1} of $total',
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (type == 1)
                        const Text(
                          'The meaning of\n"scraped"?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else ...[
                        const Picture(
                          'knee',
                          height: 160,
                          width: double.infinity,
                          radius: 20,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'My arm is ┄┄┄┄',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ],
                    const SizedBox(height: 28),
                    if (type == 1)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: .88,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: List.generate(
                          4,
                          (i) => InkWell(
                            key: ValueKey('answer-$i'),
                            onTap: () => setState(() => selected = i),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected == i ? teal : Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 14,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w600,
                                      color: selected == i ? Colors.white : ink,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    ['Xước', 'Gãy', 'Sẹo', 'Vẩy'][i],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: selected == i ? Colors.white : ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ...List.generate(
                        4,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: AnswerOption(
                            index: i,
                            label: [
                              'scraped',
                              'scratch',
                              type == 2 ? 'broken' : 'scar',
                              'scab',
                            ][i],
                            selected: selected == i,
                            onTap: () => setState(() => selected = i),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
              child: ActionButton(
                'Next',
                key: const ValueKey('quiz-next'),
                onTap: selected < 0 ? null : _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    key: ValueKey('answer-$index'),
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? blue.withValues(alpha: .04) : Colors.white,
        border: Border.all(color: selected ? blue : const Color(0xFFDADADD)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: selected ? blue : soft,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              String.fromCharCode(65 + index),
              style: TextStyle(color: selected ? Colors.white : muted),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: selected ? blue : muted, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}
