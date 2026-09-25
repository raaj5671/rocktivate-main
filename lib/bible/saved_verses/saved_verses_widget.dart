import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kVerseFavoritesPrefsKey = 'bible_verse_favorites_v2';

class _SavedVerse {
  const _SavedVerse({
    required this.key,
    required this.bibleId,
    required this.version,
    required this.chapterId,
    required this.verseNumber,
    required this.reference,
    required this.text,
    required this.savedAt,
  });

  final String key;
  final String? bibleId;
  final String? version;
  final String chapterId;
  final String verseNumber;
  final String reference;
  final String text;
  final int savedAt;

  factory _SavedVerse.fromEntry(String key, Map<String, dynamic> data) {
    return _SavedVerse(
      key: key,
      bibleId: data['bibleId']?.toString(),
      version: data['version']?.toString(),
      chapterId: data['chapterId']?.toString() ?? '',
      verseNumber: data['verseNumber']?.toString() ?? '',
      reference: data['reference']?.toString() ?? '',
      text: data['text']?.toString() ?? '',
      savedAt: (data['savedAt'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Lists every verse favorited from the Bible reader (see the "Favorites"
/// action in chapter_data_widget.dart's verse-action sheet), letting the
/// reader jump back to one in its original translation or remove it.
class SavedVersesWidget extends StatefulWidget {
  const SavedVersesWidget({super.key});

  static String routeName = 'SavedVerses';
  static String routePath = '/savedVerses';

  @override
  State<SavedVersesWidget> createState() => _SavedVersesWidgetState();
}

class _SavedVersesWidgetState extends State<SavedVersesWidget> {
  List<_SavedVerse> _verses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kVerseFavoritesPrefsKey);
    var verses = <_SavedVerse>[];
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        verses = decoded.entries
            .map((entry) => _SavedVerse.fromEntry(
                entry.key, entry.value as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
      } catch (_) {
        // Ignore a corrupted entry and show an empty list.
      }
    }
    if (!mounted) return;
    setState(() {
      _verses = verses;
      _loading = false;
    });
  }

  Future<void> _remove(_SavedVerse verse) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kVerseFavoritesPrefsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.remove(verse.key);
      await prefs.setString(_kVerseFavoritesPrefsKey, jsonEncode(decoded));
    } catch (_) {
      return;
    }
    if (!mounted) return;
    setState(() => _verses.removeWhere((v) => v.key == verse.key));
  }

  void _openVerse(_SavedVerse verse) {
    context.pushNamed(
      ChapterDataWidget.routeName,
      queryParameters: {
        'title': serializeParam(verse.reference, ParamType.String),
        'bibleid': serializeParam(verse.bibleId, ParamType.String),
        'chapterid': serializeParam(verse.chapterId, ParamType.String),
        'version': serializeParam(verse.version, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final tileBg = isDark ? const Color(0xFF1C1C1F) : const Color(0xFFECECEC);

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0.0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Saved Verses',
          style: GoogleFonts.interTight(
            color: textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            )
          : _verses.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Verses you favorite in the Bible reader will show up here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: secondaryTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _verses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                  itemBuilder: (context, index) {
                    final verse = _verses[index];
                    return InkWell(
                      onTap: () => _openVerse(verse),
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: tileBg,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${verse.reference}:${verse.verseNumber}'
                                    '${(verse.version ?? '').isNotEmpty ? ' (${verse.version})' : ''}',
                                    style: GoogleFonts.interTight(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _remove(verse),
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: secondaryTextColor,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              verse.text,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSerif(
                                color: textColor,
                                fontSize: 14.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
