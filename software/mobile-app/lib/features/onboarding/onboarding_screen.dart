import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/theme/design_tokens.dart';

class _Page {
  const _Page(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _Page(Icons.auto_awesome_outlined, 'One frame, many looks',
      'Recolor your Shade Shifter frame in seconds — a different look for every moment.'),
  _Page(Icons.view_in_ar_outlined, 'Whole frame or zone by zone',
      'Style the front and each temple independently, or the whole frame at once.'),
  _Page(Icons.bookmark_added_outlined, 'Save your looks',
      'Keep favourite configurations and re-apply them any time, on any frame.'),
  _Page(Icons.bluetooth_audio_outlined, 'Bluetooth control',
      'Your frame is controlled over Bluetooth. We only ask for it when you pair.'),
  _Page(Icons.smart_toy_outlined, 'No frame yet? Try the simulator',
      'Explore the full experience with a built-in virtual frame — no hardware needed.'),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
          duration: ShadeTokens.motionBase, curve: Curves.easeOut);
    } else {
      context.go(Routes.pairing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(Routes.pairing),
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) => _OnboardingPage(_pages[i]),
              ),
            ),
            _Dots(count: _pages.length, index: _index),
            Padding(
              padding: const EdgeInsets.all(ShadeTokens.space5),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(isLast ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage(this.page);
  final _Page page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ShadeTokens.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ShadeTokens.spectral.withValues(alpha: 0.15),
            ),
            child: Icon(page.icon, size: 44, color: ShadeTokens.spectral),
          ),
          const SizedBox(height: ShadeTokens.space6),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: ShadeTokens.space3),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: ShadeTokens.motionFast,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? ShadeTokens.spectral : ShadeTokens.mist,
            borderRadius: BorderRadius.circular(ShadeTokens.radiusPill),
          ),
        );
      }),
    );
  }
}
