import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../../data/catalog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool subscriptions = false;
  int _banner = 0;
  final _banners = PageController(viewportFraction: .88);

  @override
  void dispose() {
    _banners.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      bottomNavigationBar: const BottomTabs(0),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const PageHeading('Hi, Steven !', 'Learn new sentences right away'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => subscriptions = false),
                    child: Column(
                      children: [
                        Text(
                          'NEW FEED',
                          style: TextStyle(
                            color: subscriptions ? muted : blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 2,
                          width: 40,
                          color: subscriptions ? Colors.transparent : blue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  InkWell(
                    onTap: () => setState(() => subscriptions = true),
                    child: Column(
                      children: [
                        Text(
                          'SUBSCRIPTION',
                          style: TextStyle(
                            color: subscriptions ? blue : muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 2,
                          width: 40,
                          color: subscriptions ? blue : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () => go(context, '/notifications'),
                    icon: const Badge(
                      label: Text('3'),
                      backgroundColor: coral,
                      child: Icon(CupertinoIcons.bell, color: green),
                    ),
                  ),
                ],
              ),
            ),
            if (subscriptions && store.subscriptions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(CupertinoIcons.person_2, size: 38, color: muted),
                    const SizedBox(height: 12),
                    const Text('Your subscribed channels will appear here.'),
                    TextButton(
                      onPressed: () => go(context, '/channel'),
                      child: const Text('Discover channels'),
                    ),
                  ],
                ),
              )
            else ...[
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: PersonRow('Charlie Herrera', 'charlie', size: 24),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 142,
                child: PageView.builder(
                  controller: _banners,
                  onPageChanged: (i) => setState(() => _banner = i),
                  itemCount: 3,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Picture(
                            i == 0
                                ? 'airport'
                                : i == 1
                                ? 'travel'
                                : 'course',
                          ),
                          ColoredBox(color: blue.withValues(alpha: .73)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'ENGLISH TOURISM',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  i == 0
                                      ? 'Through the airport security door'
                                      : i == 1
                                      ? 'Make every journey a conversation'
                                      : 'Learn English in real life',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                ActionButton(
                                  'Learn free now',
                                  height: 40,
                                  color: Colors.white,
                                  foreground: blue,
                                  onTap: () => go(context, '/post'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Container(
                    width: i == _banner ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: blue.withValues(alpha: i == _banner ? 1 : .5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionTitle(
                  'When get hurt',
                  action: 'view all',
                  onTap: () => go(context, '/category/When get hurt'),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: PersonRow('Ellen Jacobs', 'ellen', size: 24),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, i) {
                    final s = sentences[(i + 1) % sentences.length];
                    return SizedBox(
                      width: 254,
                      child: InkWell(
                        key: i == 0 ? const ValueKey('home-post') : null,
                        onTap: () => go(context, '/post'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Picture(
                                  s.image,
                                  width: 254,
                                  height: 128,
                                  radius: 20,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0x99684829),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      s.duration,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              s.english.replaceAll(
                                i == 0 ? 'scratch' : 'scraped',
                                '┄┄┄┄',
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.translation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionTitle(
                  'Keep learning',
                  action: 'courses',
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed('/speak'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: ActionButton(
                  'Practice your vocabulary',
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed('/topics'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SentenceList extends StatelessWidget {
  const SentenceList({super.key, this.items = sentences});
  final List<Sentence> items;
  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => go(context, '/post'),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Picture(s.image, width: 90, height: 54, radius: 12),
                      Positioned(
                        right: 6,
                        bottom: 4,
                        child: Text(
                          s.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.english, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          s.translation,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );
}
