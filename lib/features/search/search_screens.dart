import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';
import '../../data/catalog.dart';
import '../home/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '', type = 'Sentence';
  @override
  Widget build(BuildContext context) {
    final results = sentences
        .where(
          (s) => '${s.english} ${s.translation}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return Scaffold(
      bottomNavigationBar: const BottomTabs(1),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const PageHeading(
              'Find anything!',
              'Searching anything you want to learn here.',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                key: const ValueKey('search-field'),
                onChanged: (v) => setState(() => query = v.trim()),
                decoration: const InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search, color: ink),
                  filled: true,
                  fillColor: soft,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            ),
            const SizedBox(height: 36),
            if (query.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Results (${results.length})'),
                    const SizedBox(height: 18),
                    if (results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'No sentences found. Try “knee” or “scratch”.',
                          style: TextStyle(color: muted),
                        ),
                      )
                    else
                      SentenceList(items: results),
                  ],
                ),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choose\na category',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 166,
                      child: FilterPills(
                        const ['Sentence', 'Speak'],
                        type,
                        (v) => setState(() => type = v),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, i) {
                    final label = ['Movie', 'Travel', 'Music'][i];
                    return InkWell(
                      onTap: () => go(
                        context,
                        type == 'Speak' ? '/course' : '/category/$label',
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: SizedBox(
                          width: 140,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Picture(['movie', 'travel', 'music'][i]),
                              ColoredBox(
                                color: [
                                  dark,
                                  const Color(0xFF719383),
                                  const Color(0xFF00AEEF),
                                ][i].withValues(alpha: .78),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      [
                                        CupertinoIcons.film,
                                        CupertinoIcons.airplane,
                                        CupertinoIcons.headphones,
                                      ][i],
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionTitle(
                  'Channel',
                  action: 'view all',
                  onTap: () => go(context, '/channels'),
                ),
              ),
              const Padding(padding: EdgeInsets.all(24), child: ChannelList()),
            ],
          ],
        ),
      ),
    );
  }
}

class ChannelList extends StatelessWidget {
  const ChannelList({super.key, this.movie = false});
  final bool movie;
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      3,
      (i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PersonRow(
          movie
              ? ['Filmic Box', 'Cartoon channel', 'Movieclips'][i]
              : ['Cornelia Gordon', 'Chase Bailey', 'Betty Carroll'][i],
          ['cornelia', 'chase', 'betty'][i],
          subtitle: '129k subscribers',
          onTap: () => go(context, '/channel'),
        ),
      ),
    ),
  );
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen(this.category, {super.key});
  final String category;
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selected = 'Up';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: topBar(context, widget.category),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SectionTitle(
          'Topic suggest (22)',
          action: 'view all',
          onTap: () => go(context, '/topics'),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                    'Up',
                    'Nemo',
                    'Christmas',
                    'Coco',
                    'Frozen',
                    'Cartoon',
                    'Superheroes',
                    'OST',
                    'Disney',
                  ]
                  .map(
                    (s) => ChoiceChip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      selected: selected == s,
                      selectedColor: blue.withValues(alpha: .18),
                      onSelected: (_) => setState(() => selected = s),
                      side: BorderSide.none,
                      backgroundColor: soft,
                      showCheckmark: false,
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 28),
        SectionTitle(
          'Channel (32)',
          action: 'view all',
          onTap: () => go(context, '/channels'),
        ),
        const SizedBox(height: 20),
        const ChannelList(movie: true),
        const SizedBox(height: 24),
        SectionTitle(selected == 'Up' ? 'Sentences' : '$selected · Sentences'),
        const SizedBox(height: 20),
        const SentenceList(),
      ],
    ),
  );
}

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});
  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  String filter = 'Newest';
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context),
        subscribed = store.subscriptions.contains('Cornelia Gordon');
    return Scaffold(
      appBar: topBar(context, ''),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 14),
          const PersonRow(
            'Cornelia Gordon',
            'cornelia',
            subtitle: '129k subscribers\n162 sentences',
            size: 96,
          ),
          const SizedBox(height: 16),
          const Text(
            'Check out the best scenes of every movie!',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68),
            child: ActionButton(
              subscribed ? '✓ Subscribed' : '+ Subscribe',
              key: const ValueKey('subscribe-channel'),
              height: 40,
              onTap: () => store.toggleSubscription('Cornelia Gordon'),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sentences (162)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                width: 152,
                child: FilterPills(
                  const ['Newest', 'Watched'],
                  filter,
                  (v) => setState(() => filter = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (filter == 'Watched')
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Open a lesson to start your watch history.',
                style: TextStyle(color: muted),
              ),
            )
          else
            const SentenceList(),
        ],
      ),
    );
  }
}
