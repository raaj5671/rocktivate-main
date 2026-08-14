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
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.70),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
