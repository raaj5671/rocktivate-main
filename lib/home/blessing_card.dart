import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _MoodBlessing {
  const _MoodBlessing(this.subtitle, this.quote, this.reference, this.duration);
  final String subtitle;
  final String quote;
  final String reference;
  final String duration;
}

const _kMoodBlessings = {
  'Joyful': _MoodBlessing(
    'A joyful reflection to celebrate this moment.',
    '"The joy of the Lord is your strength."',
    'Nehemiah 8:10',
    '~25 seconds',
  ),
  'Hopeful': _MoodBlessing(
    'A short blessing to encourage you in your journey today.',
    '"For I know the plans I have for you..."',
    'Jeremiah 29:11',
    '~25 seconds',
  ),
  'Peaceful': _MoodBlessing(
    'A calming reflection to steady your heart.',
    '"Peace I leave with you; my peace I give you."',
    'John 14:27',
    '~30 seconds',
  ),
  'Grateful': _MoodBlessing(
    'A word of thanks to carry with you today.',
    '"Give thanks in all circumstances."',
    '1 Thessalonians 5:18',
    '~25 seconds',
  ),
};

const _kBlessingGold = Color(0xFFB8823A);

/// "Your blessing for today" card, driven by whichever mood is selected in
/// [MoodPicker] above it. The play button is visual-only for now — no real
/// audio narration backend exists yet, same placeholder state the mood
/// wheel it replaces was already in.
class BlessingCard extends StatefulWidget {
  const BlessingCard({super.key, required this.mood});

  final String mood;

  @override
  State<BlessingCard> createState() => _BlessingCardState();
}

class _BlessingCardState extends State<BlessingCard> {
  bool _isPlaying = false;

  void _togglePlay() => setState(() => _isPlaying = !_isPlaying);

  @override
  Widget build(BuildContext context) {
    final blessing =
        _kMoodBlessings[widget.mood] ?? _kMoodBlessings['Hopeful']!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: SizedBox(
        height: 210.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_background.jpg',
              fit: BoxFit.cover,
            ),
            // Left-to-right scrim so the headline/body text stays legible
            // over the photo, while the quote on the right can sit
            // directly on the image like the reference design.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _scrimBackgroundColor(context),
                      _scrimBackgroundColor(context),
                      _scrimBackgroundColor(context).withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 0.78],
                  ),
                ),
              ),
            ),
            // Bottom scrim purely for the quote text's contrast against the
            // photo, independent of the left-right one above.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.35),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR BLESSING FOR TODAY',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF7A4A1F),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'Stay ${widget.mood}',
                          style: GoogleFonts.interTight(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          blessing.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.black87,
                            fontSize: 13.0,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          children: [
                            InkWell(
                              onTap: _togglePlay,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: const BoxDecoration(
                                  color: _kBlessingGold,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Play Blessing',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  blessing.duration,
                                  style: GoogleFonts.inter(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            blessing.quote,
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            blessing.reference,
                            style: GoogleFonts.interTight(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Matches whichever theme background the rest of the app is using, rather
// than a hardcoded color, so the left-right scrim above blends in.
Color _scrimBackgroundColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF141414) : const Color(0xFFFBF3E7);
}
