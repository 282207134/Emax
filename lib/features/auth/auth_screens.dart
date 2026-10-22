import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_store.dart';
import '../../core/ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pushReplacementNamed(
          AppScope.of(context).onboarded ? '/home' : '/onboarding/0',
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Picture(
        'splash_logo',
        width: 151,
        height: 60,
        fit: BoxFit.contain,
      ),
    ),
  );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen(this.index, {super.key});
  final int index;
  static const titles = [
    'Many sentence to learn',
    'Easy improve speaking',
    'Interesting learn vocabulary',
  ];
  static const subtitles = [
    'Easy to learn vocabulary with a variety of sentence',
    'Speaking courses in combination sentences and vocabulary',
    'Learn vocabulary by playing game card to memorize faster',
  ];
  static const images = [
    'onboarding_sentences',
    'onboarding_speaking',
    'onboarding_words',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => go(context, '/signin'),
                      child: const Text('Skip', style: TextStyle(color: muted)),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .13),
                  Picture(
                    images[index],
                    width: 301,
                    height: 195,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    titles[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitles[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: muted,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        margin: const EdgeInsets.all(4),
                        height: 6,
                        width: i == index ? 16 : 6,
                        decoration: BoxDecoration(
                          color: blue.withValues(alpha: i == index ? 1 : .3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionButton(
                      'Get started',
                      key: const ValueKey('get-started'),
                      onTap: () => go(
                        context,
                        index < 2 ? '/onboarding/${index + 1}' : '/signup',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.signUp = false});
  final bool signUp;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscured = true;
  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await AppScope.of(context).finishOnboarding();
    if (mounted) home(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: Picture('library')),
        Positioned.fill(child: ColoredBox(color: dark.withValues(alpha: .75))),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => back(context),
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!widget.signUp) ...[
                  const SizedBox(height: 20),
                  const Picture(
                    'logo',
                    width: 150,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    widget.signUp ? 'Create An Account' : 'Welcome Back!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(40, 28, 40, 35),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const ValueKey('email-field'),
                          initialValue: 'amask27@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Username or Email',
                          ),
                          validator: (s) =>
                              s != null && s.contains('@') && s.contains('.')
                              ? null
                              : 'Enter a valid email address',
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          key: const ValueKey('password-field'),
                          controller: _password,
                          obscureText: _obscured,
                          textInputAction: widget.signUp
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (!widget.signUp) _submit();
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              tooltip: 'Show password',
                              icon: Icon(
                                _obscured
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscured = !_obscured),
                            ),
                          ),
                          validator: (s) => (s?.length ?? 0) >= 6
                              ? null
                              : 'Use at least 6 characters',
                        ),
                        if (widget.signUp) ...[
                          const SizedBox(height: 24),
                          TextFormField(
                            key: const ValueKey('confirm-field'),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Re Password',
                            ),
                            validator: (s) => s == _password.text
                                ? null
                                : 'Passwords do not match',
                          ),
                        ],
                        const SizedBox(height: 40),
                        ActionButton(
                          widget.signUp ? 'Sign up' : 'Sign in',
                          key: const ValueKey('auth-submit'),
                          onTap: _submit,
                        ),
                        const SizedBox(height: 28),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Or sign in with',
                                style: TextStyle(fontSize: 13, color: muted),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                              [
                                    ('f', const Color(0xFF3C66AF)),
                                    ('g⁺', const Color(0xFFCC4A32)),
                                    ('t', const Color(0xFF48ABE7)),
                                  ]
                                  .map(
                                    (social) => IconButton.filled(
                                      tooltip: 'Social sign in demo',
                                      style: IconButton.styleFrom(
                                        backgroundColor: social.$2,
                                        minimumSize: const Size(48, 48),
                                      ),
                                      onPressed: () => message(
                                        context,
                                        'Social sign in is not connected in this local demo. Use email to continue.',
                                      ),
                                      icon: Text(
                                        social.$1,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 28),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacementNamed(
                                widget.signUp ? '/signin' : '/signup',
                              ),
                          child: Text(
                            widget.signUp
                                ? 'Have an account? Sign In'
                                : 'Don’t have account? Sign Up',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          key: const ValueKey('demo-entry'),
                          onPressed: () async {
                            await AppScope.of(context).finishOnboarding();
                            if (context.mounted) home(context);
                          },
                          child: const Text(
                            'Explore demo',
                            style: TextStyle(fontSize: 13, color: muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
