import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodOption {
  const MoodOption(this.label, this.icon);
  final String label;
  final IconData icon;
}

const kMoodOptions = [
  MoodOption('Joyful', Icons.sentiment_satisfied_alt_rounded),
  MoodOption('Hopeful', Icons.favorite_rounded),
  MoodOption('Peaceful', Icons.eco_rounded),
  MoodOption('Grateful', Icons.wb_sunny_rounded),
];

const _kMoodGold = Color(0xFFB8823A);

/// A row of tappable mood pills replacing the earlier circular mood wheel —
/// same purpose (picking a mood to drive the blessing shown below it), just
/// a flatter, simpler control to match the reference design.
class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  final String selectedMood;
  final ValueChanged<String> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? const Color(0xFF1C1C1F) : Colors.white;
    final unselectedBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : _kMoodGold.withValues(alpha: 0.30);

    return Row(
      children: [
        for (final option in kMoodOptions) ...[
          Expanded(
            child: _MoodPill(
              option: option,
              selected: option.label == selectedMood,
              unselectedBg: unselectedBg,
              unselectedBorder: unselectedBorder,
              onTap: () => onMoodSelected(option.label),
            ),
          ),
          if (option != kMoodOptions.last) const SizedBox(width: 10.0),
        ],
      ],
    );
  }
}

class _MoodPill extends StatelessWidget {
  const _MoodPill({
    required this.option,
    required this.selected,
    required this.unselectedBg,
    required this.unselectedBorder,
    required this.onTap,
  });

  final MoodOption option;
  final bool selected;
  final Color unselectedBg;
  final Color unselectedBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : _kMoodGold;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: selected ? _kMoodGold : unselectedBg,
          borderRadius: BorderRadius.circular(16.0),
          border: selected ? null : Border.all(color: unselectedBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(option.icon, color: foreground, size: 22.0),
            const SizedBox(height: 6.0),
            Text(
              option.label,
              style: GoogleFonts.inter(
                color: foreground,
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
