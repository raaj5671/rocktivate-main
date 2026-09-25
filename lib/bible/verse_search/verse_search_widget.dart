import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full verse-text search within the current Bible version, backed by the
/// Bible API's `/search` endpoint. Presented as content inside the chapter
/// reading screen's floating bottom sheet (see `_FloatingSheet` in
/// chapter_data_widget.dart) rather than owning its own Scaffold/AppBar, so
/// it matches the rest of the Bible feature's sheet UI.
class VerseSearchWidget extends StatefulWidget {
  const VerseSearchWidget({
    super.key,
    required this.bibleId,
    this.version,
    this.onAskAi,
  });

  final String? bibleId;
  final String? version;
  // Lets the parent (which owns the AI response sheet) handle "Ask AI"
  // instead of this widget knowing about that presentation itself.
  final void Function(String query)? onAskAi;

  @override
  State<VerseSearchWidget> createState() => _VerseSearchWidgetState();
}

class _VerseSearchWidgetState extends State<VerseSearchWidget> {
  final _searchController = TextEditingController();
  bool _loading = false;
  String? _error;
  List _results = [];
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    // Rebuilds as the reader types so the "Ask AI" row can show/hide live.
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
      _searched = true;
    });
    try {
      final response = await BibleAPIGroup.searchCall.call(
        bibleID: widget.bibleId,
        query: trimmed,
      );
      final verses = BibleAPIGroup.searchCall.verses(response.jsonBody) ?? [];
      if (!mounted) return;
      setState(() {
        _results = verses;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong searching. Please try again.';
        _loading = false;
      });
    }
  }

  void _openResult(dynamic verse) {
    final reference = getJsonField(verse, r'''$.reference''').toString();
    final chapterId = getJsonField(verse, r'''$.chapterId''').toString();
    // Drop the trailing ":verse" so the reader opens on the chapter, e.g.
    // "John 12:25" -> "John 12".
    final chapterTitle =
        reference.contains(':') ? reference.split(':').first : reference;

    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
    context.pushNamed(
      ChapterDataWidget.routeName,
      queryParameters: {
        'title': serializeParam(chapterTitle, ParamType.String),
        'bibleid': serializeParam(widget.bibleId, ParamType.String),
        'chapterid': serializeParam(chapterId, ParamType.String),
        'version': serializeParam(widget.version, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final searchFieldBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;
    final tileBg = isDark ? const Color(0xFF262629) : const Color(0xFFECECEC);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: _runSearch,
          style: GoogleFonts.inter(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: 'Search verses (e.g. "love" or "John 3:16")',
            hintStyle: GoogleFonts.inter(color: secondaryTextColor),
            prefixIcon: Icon(Icons.search_rounded, color: secondaryTextColor),
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_forward_rounded,
                  color: secondaryTextColor),
              onPressed: () => _runSearch(_searchController.text),
            ),
            filled: true,
            fillColor: searchFieldBg,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (widget.onAskAi != null &&
            _searchController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 10.0),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(14.0),
            onTap: () =>
                widget.onAskAi!.call(_searchController.text.trim()),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primary
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 18.0,
                      color: FlutterFlowTheme.of(context).primary),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      'Ask AI: "${_searchController.text.trim()}"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: 18.0, color: secondaryTextColor),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16.0),
        Expanded(
          child: _loading
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                )
              : _error != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: secondaryTextColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    )
                  : !_searched
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              'Search this version for a word, phrase, '
                              'or reference.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: secondaryTextColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        )
                      : _results.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Center(
                                child: Text(
                                  'No results found.',
                                  style: GoogleFonts.inter(
                                    color: secondaryTextColor,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              itemCount: _results.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8.0),
                              itemBuilder: (context, index) {
                                final verse = _results[index];
                                final reference = getJsonField(
                                        verse, r'''$.reference''')
                                    .toString();
                                final text =
                                    getJsonField(verse, r'''$.text''')
                                        .toString();

                                return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.0),
                                  onTap: () => _openResult(verse),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14.0),
                                    decoration: BoxDecoration(
                                      color: tileBg,
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reference,
                                          style: GoogleFonts.interTight(
                                            color: primaryTextColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          text.trim(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSerif(
                                            color: secondaryTextColor,
                                            fontSize: 14.0,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
        ),
      ],
    );
  }
}
