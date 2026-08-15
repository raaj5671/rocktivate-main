import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Fallback verse used if the network fetch fails or times out, so the
// splash never gets stuck with nothing to show.
const _kFallbackVerseText =
    'For I know the plans I have for you, declares the LORD, plans to '
    'prosper you and not to harm you, plans to give you hope and a future.';
const _kFallbackVerseReference = 'Jeremiah 29:11';

/// Shows a background image with a freshly-fetched Bible verse while the
/// app decides where to route the user, then hands off to [child].
class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key, required this.child});

  final Widget child;

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  bool _showSplash = true;
  String? _verseText;
  String? _verseReference;

  @override
  void initState() {
    super.initState();
    _loadVerseAndProceed();
  }

  Future<void> _loadVerseAndProceed() async {
    final minDisplay = Future<void>.delayed(const Duration(seconds: 12));
    try {
      final response = await http
          .get(Uri.parse(
              'https://beta.ourmanna.com/api/v1/get?format=json&order=random'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final details = (data['verse'] as Map<String, dynamic>)['details']
            as Map<String, dynamic>;
        _verseText = details['text'] as String?;
        _verseReference = details['reference'] as String?;
      }
    } catch (_) {
      // Fetch failed or timed out; fall back below.
    }
    _verseText ??= _kFallbackVerseText;
    _verseReference ??= _kFallbackVerseReference;
    if (mounted) {
      setState(() {});
    }

    await minDisplay;
    if (mounted) {
      setState(() => _showSplash = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: _showSplash
          ? _SplashContent(
              key: const ValueKey('splash'),
              verseText: _verseText,
              verseReference: _verseReference,
            )
          : KeyedSubtree(
              key: const ValueKey('app'),
              child: widget.child,
            ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({
    super.key,
    required this.verseText,
    required this.verseReference,
  });

  final String? verseText;
  final String? verseReference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.jpg',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.70),
                ],
                stops: const [0.0, 0.25, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12.0),
                  const _AnimatedAppName(),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: verseText == null
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 22.0,
                            height: 22.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white70),
                            ),
                          )
                        : Column(
                            key: const ValueKey('verse'),
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '"$verseText"',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                verseReference ?? '',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedAppName extends StatefulWidget {
  const _AnimatedAppName();

  @override
  State<_AnimatedAppName> createState() => _AnimatedAppNameState();
}

class _AnimatedAppNameState extends State<_AnimatedAppName>
    with TickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
  );
  late final Animation<double> _entranceScale = Tween<double>(
          begin: 0.82, end: 1.0)
      .animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0.0, 0.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
  late final Animation<double> _pulseScale = Tween<double>(
    begin: 1.0,
    end: 1.035,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  late final Animation<double> _pulseGlow = Tween<double>(
    begin: 0.4,
    end: 0.85,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    // Play the one-shot entrance first, then loop a gentle breathing
    // glow so the wordmark keeps feeling alive for the whole splash,
    // however long it's displayed for.
    _entrance.forward().whenComplete(() {
      if (mounted) {
        _pulse.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _entranceScale,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseScale.value,
                child: Text(
                  'Rocktivate',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 58.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20.0,
                        offset: const Offset(0.0, 4.0),
                      ),
                      Shadow(
                        color: Colors.white
                            .withValues(alpha: _pulseGlow.value * 0.5),
                        blurRadius: 28.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
