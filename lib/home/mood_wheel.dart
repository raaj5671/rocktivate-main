import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';

const _kWheelGlow = Color(0xFFB87A3D);
const _kWheelGold = Color(0xFFD4AF37);

// Placeholder copy until the AI reflection backend exists. Keyed by mood so
// the preview line and duration estimate update as the selection changes.
const _kDefaultPreviewCopy = {
  'Bless': 'A short blessing to carry with you today',
  'Grateful': "A short word of encouragement for when you're feeling grateful",
  'Peaceful': 'A calming reflection to steady your heart',
  'Hopeful': 'An uplifting word for when hope feels distant',
  'Joyful': 'A joyful reflection to celebrate this moment',
};
const _kDefaultDuration = {
  'Bless': '~25 sec',
  'Grateful': '~30 sec',
  'Peaceful': '~35 sec',
  'Hopeful': '~30 sec',
  'Joyful': '~25 sec',
};

class MoodWheel extends StatefulWidget {
  const MoodWheel({
    super.key,
    this.moods = const ['Bless', 'Grateful', 'Peaceful', 'Hopeful', 'Joyful'],
    this.initialIndex = 0,
    this.onMoodChanged,
    this.onPlayPressed,
    this.diameter = 260.0,
    this.previewCopy = _kDefaultPreviewCopy,
    this.duration = _kDefaultDuration,
  });

  final List<String> moods;
  final int initialIndex;
  final ValueChanged<String>? onMoodChanged;
  final VoidCallback? onPlayPressed;
  final double diameter;
  final Map<String, String> previewCopy;
  final Map<String, String> duration;

  @override
  State<MoodWheel> createState() => _MoodWheelState();
}

class _MoodWheelState extends State<MoodWheel>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex = widget.initialIndex;
  bool _isPlaying = false;
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  double get _sectorAngle => (2 * math.pi) / widget.moods.length;

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _selectFromLocalPosition(Offset localPosition, double areaSize) {
    final center = Offset(areaSize / 2, areaSize / 2);
    final delta = localPosition - center;
    if (delta.distance < 12) {
      // Ignore drags too close to the center to avoid a jumpy selection.
      return;
    }
    // Angle measured clockwise starting from the top (12 o'clock).
    var angle = math.atan2(delta.dx, -delta.dy);
    if (angle < 0) angle += 2 * math.pi;
    final index = ((angle + _sectorAngle / 2) / _sectorAngle).floor() %
        widget.moods.length;
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
      widget.onMoodChanged?.call(widget.moods[index]);
    }
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
    widget.onPlayPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // Extra room around the ring for the outside mood labels.
    final areaSize = widget.diameter + 92.0;
    final ringRadius = widget.diameter / 2;
    final selectedAngle = _sectorAngle * _selectedIndex;
    final currentMood = widget.moods[_selectedIndex];
    final previewLine = widget.previewCopy[currentMood] ??
        "A short reflection for how you're feeling";
    final durationLabel = widget.duration[currentMood] ?? '~30 sec';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: areaSize,
          height: areaSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) =>
                _selectFromLocalPosition(details.localPosition, areaSize),
            onPanUpdate: (details) =>
                _selectFromLocalPosition(details.localPosition, areaSize),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                final pulse = _isPlaying ? _pulseController.value : 0.0;
                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Soft ambient glow behind the ring; breathes while
                    // "listening" so silence doesn't read as broken.
                    Container(
                      width: widget.diameter * 0.86,
                      height: widget.diameter * 0.86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _kWheelGlow.withValues(
                              alpha: _isPlaying ? 0.30 + 0.25 * pulse : 0.35,
                            ),
                            blurRadius: _isPlaying ? 50.0 + 20.0 * pulse : 60.0,
                            spreadRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: Size(widget.diameter, widget.diameter),
                      painter: _MoodRingPainter(
                        progressAngle: selectedAngle,
                        glowColors: [_kWheelGlow, _kWheelGlow],
                        ringColor: theme.primaryText.withValues(alpha: 0.18),
                        progressColor: _kWheelGlow,
                        glowPulse: _isPlaying ? pulse : null,
                      ),
                    ),
                    for (var i = 0; i < widget.moods.length; i++)
                      _MoodDot(
                        angle: _sectorAngle * i,
                        radius: ringRadius,
                        areaSize: areaSize,
                        selected: i == _selectedIndex,
                        color: _kWheelGold,
                      ),
                    for (var i = 0; i < widget.moods.length; i++)
                      _MoodLabel(
                        label: widget.moods[i],
                        angle: _sectorAngle * i,
                        radius: ringRadius,
                        areaSize: areaSize,
                        selected: i == _selectedIndex,
                        selectedColor: theme.primaryText,
                        unselectedColor: theme.secondaryText,
                      ),
                    _PlayButton(
                      isPlaying: _isPlaying,
                      pulse: pulse,
                      onPressed: _togglePlay,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        SizedBox(
          width: widget.diameter + 40.0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              previewLine,
              key: ValueKey(currentMood),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 15.0,
                height: 1.35,
                color: theme.secondaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            durationLabel,
            key: ValueKey('$currentMood-duration'),
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: theme.secondaryText.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodRingPainter extends CustomPainter {
  _MoodRingPainter({
    required this.progressAngle,
    required this.glowColors,
    required this.ringColor,
    required this.progressColor,
    this.glowPulse,
  });

  final double progressAngle;
  final List<Color> glowColors;
  final Color ringColor;
  final Color progressColor;
  // Non-null while the reflection is "playing"; drives a breathing glow.
  final double? glowPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Soft radial glow fill inside the ring.
    final glowAlpha = glowPulse != null ? 0.22 + 0.18 * glowPulse! : 0.28;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColors.first.withValues(alpha: glowAlpha),
          glowColors.last.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // Thin ring outline.
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = ringColor;
    canvas.drawCircle(center, radius, ringPaint);

    // Progress arc from the top, clockwise to the selected mood.
    if (progressAngle > 0) {
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..color = progressColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progressAngle,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoodRingPainter oldDelegate) {
    return oldDelegate.progressAngle != progressAngle ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.glowPulse != glowPulse;
  }
}

class _MoodDot extends StatelessWidget {
  const _MoodDot({
    required this.angle,
    required this.radius,
    required this.areaSize,
    required this.selected,
    required this.color,
  });

  final double angle;
  final double radius;
  final double areaSize;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dx = radius * math.sin(angle);
    final dy = -radius * math.cos(angle);
    final size = selected ? 16.0 : 9.0;

    return Positioned(
      left: areaSize / 2 + dx - size / 2,
      top: areaSize / 2 + dy - size / 2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.white,
          border:
              selected ? null : Border.all(color: color.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodLabel extends StatelessWidget {
  const _MoodLabel({
    required this.label,
    required this.angle,
    required this.radius,
    required this.areaSize,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final String label;
  final double angle;
  final double radius;
  final double areaSize;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    // Labels sit just outside the ring, at the same angle as their dot.
    final labelRadius = radius + 26.0;
    final dx = labelRadius * math.sin(angle);
    final dy = -labelRadius * math.cos(angle);
    const labelWidth = 92.0;

    return Positioned(
      left: areaSize / 2 + dx - labelWidth / 2,
      top: areaSize / 2 + dy - 9.0,
      child: SizedBox(
        width: labelWidth,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? selectedColor : unselectedColor,
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isPlaying,
    required this.pulse,
    required this.onPressed,
  });

  final bool isPlaying;
  final double pulse;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = isPlaying ? 1.0 + 0.08 * pulse : 1.0;
    final glowAlpha = isPlaying ? 0.16 + 0.14 * pulse : 0.16;

    return Transform.scale(
      scale: scale,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kWheelGlow.withValues(alpha: glowAlpha),
              border: Border.all(
                color: _kWheelGlow.withValues(alpha: isPlaying ? 0.55 : 0.35),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: _kWheelGlow,
                size: 26.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
