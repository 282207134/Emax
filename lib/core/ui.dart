import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const blue = Color(0xFF2674FF);
const ink = Color(0xFF202027);
const muted = Color(0xFF8B8B9B);
const soft = Color(0xFFEEEEF0);
const teal = Color(0xFF005F89);
const green = Color(0xFF0BB279);
const coral = Color(0xFFFF926F);
const wine = Color(0xFFBC0033);
const dark = Color(0xFF454655);

void go(BuildContext context, String path) =>
    Navigator.of(context).pushNamed(path);
void home(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
void back(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    home(context);
  }
}

void message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );

class Picture extends StatelessWidget {
  const Picture(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
  });
  final String name;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$name.png',
      width: width,
      height: height,
      fit: fit,
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onTap,
    this.color = blue,
    this.foreground = Colors.white,
    this.icon,
    this.height = 58,
  });
  final String label;
  final VoidCallback? onTap;
  final Color color, foreground;
  final IconData? icon;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
        disabledBackgroundColor: soft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key, this.trailing});
  final String title, subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
    child: Stack(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFFA5ADA8)),
              ),
            ],
          ),
        ),
        if (trailing != null)
          Align(alignment: Alignment.topRight, child: trailing),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Text(action!, style: const TextStyle(fontSize: 13)),
        ),
    ],
  );
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.color = green});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 11, color: Colors.white),
    ),
  );
}

class FilterPills extends StatelessWidget {
  const FilterPills(this.items, this.selected, this.onSelect, {super.key});
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 34,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, i) => ChoiceChip(
        label: Text(items[i], style: const TextStyle(fontSize: 12)),
        selected: selected == items[i],
        showCheckmark: false,
        onSelected: (_) => onSelect(items[i]),
        selectedColor: blue,
        backgroundColor: const Color(0xFFCDCDD1),
        labelStyle: const TextStyle(color: Colors.white),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
    ),
  );
}

class BottomTabs extends StatelessWidget {
  const BottomTabs(this.index, {super.key});
  final int index;
  static const paths = ['/home', '/search', '/speak', '/topics', '/profile'];
  static const labels = ['Home', 'Search', 'Speak', 'Word', 'Profile'];
  static const icons = [
    CupertinoIcons.rectangle_stack_person_crop,
    CupertinoIcons.search,
    CupertinoIcons.mic,
    CupertinoIcons.globe,
    CupertinoIcons.person,
  ];
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Color(0x103C80D1),
          blurRadius: 18,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 60,
        child: Row(
          children: List.generate(
            5,
            (i) => Expanded(
              child: InkWell(
                key: ValueKey('tab-$i'),
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (index != i) {
                    Navigator.of(context).pushReplacementNamed(paths[i]);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icons[i], color: index == i ? blue : muted, size: 23),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 11,
                        color: index == i ? blue : muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

PreferredSizeWidget topBar(
  BuildContext context,
  String title, {
  bool close = false,
  List<Widget>? actions,
  Color? background,
  Color? foreground,
}) => AppBar(
  backgroundColor: background,
  foregroundColor: foreground,
  title: Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  ),
  centerTitle: false,
  leading: IconButton(
    tooltip: close ? 'Close' : 'Back',
    icon: Icon(
      close ? CupertinoIcons.xmark : CupertinoIcons.arrow_left,
      size: 21,
    ),
    onPressed: () => back(context),
  ),
  actions: actions,
);

class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key, required this.onTap, this.wide = false});
  final VoidCallback onTap;
  final bool wide;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    width: wide ? double.infinity : 40,
    child: IconButton.filledTonal(
      style: IconButton.styleFrom(
        backgroundColor: soft,
        foregroundColor: ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(wide ? 16 : 12),
        ),
      ),
      onPressed: onTap,
      icon: const Icon(CupertinoIcons.arrow_right, size: 23),
    ),
  );
}

class PersonRow extends StatelessWidget {
  const PersonRow(
    this.name,
    this.image, {
    super.key,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.size = 56,
  });
  final String name, image;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double size;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Picture(image, width: size, height: size, radius: size / 3),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: size > 30 ? 16 : 13,
                  fontWeight: size > 30 ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: const TextStyle(color: muted, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          trailing!
        else if (onTap != null)
          ArrowButton(onTap: onTap!),
      ],
    ),
  );
}

class Confetti extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(8);
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width,
          y = random.nextDouble() * size.height;
      canvas.drawCircle(
        Offset(x, y),
        i % 7 == 0 ? 3 : 1.2,
        Paint()..color = const Color(0xFF16748E).withValues(alpha: .85),
      );
    }
  }

  @override
  bool shouldRepaint(Confetti oldDelegate) => false;
}
