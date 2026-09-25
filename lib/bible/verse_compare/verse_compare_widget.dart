import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCompareVersionsPrefsKey = 'bible_compare_versions';

/// A Bible version chosen for side-by-side comparison, along with whatever
/// of this verse's text has been fetched for it so far.
class _CompareVersion {
  const _CompareVersion({
    required this.id,
    required this.abbreviation,
    required this.name,
  });

  final String id;
  final String abbreviation;
  final String name;

  Map<String, String> toJson() =>
      {'id': id, 'abbreviation': abbreviation, 'name': name};

  factory _CompareVersion.fromJson(Map<String, dynamic> json) =>
      _CompareVersion(
        id: json['id']?.toString() ?? '',
        abbreviation: json['abbreviation']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}

/// Strips a single verse's API HTML down to plain, readable text — the API
/// embeds the verse number (and sometimes a pilcrim/paragraph mark) as the
/// first bit of text, which this trims off since the caller already shows
/// the verse number separately.
String _extractVerseText(String htmlContent) {
  final document = html_parser.parse(htmlContent);
  var text = document.body?.text ?? document.documentElement?.text ?? '';
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  text = text.replaceFirst(RegExp(r'^\d+\s*¶?\s*'), '');
  return text.trim();
}

/// Verse-comparison content for the Bible feature's "Compare" sheet: shows
/// the same verse across whichever versions the reader has added, with
/// Add/Edit controls to manage that list. Presented as content inside the
/// chapter screen's floating bottom sheet (see `_FloatingSheet` in
/// chapter_data_widget.dart), matching `VerseSearchWidget`'s pattern of not
/// owning its own sheet chrome.
class VerseCompareWidget extends StatefulWidget {
  const VerseCompareWidget({
    super.key,
    required this.chapterId,
    required this.verseNumber,
    required this.reference,
    this.currentBibleId,
    this.currentVersionAbbrev,
  });

  final String chapterId;
  final String verseNumber;
  final String reference;
  final String? currentBibleId;
  final String? currentVersionAbbrev;

  @override
  State<VerseCompareWidget> createState() => _VerseCompareWidgetState();
}

class _VerseCompareWidgetState extends State<VerseCompareWidget> {
  List<_CompareVersion> _versions = [];
  final Map<String, String> _verseText = {};
  final Map<String, bool> _loading = {};
  final Map<String, String> _errors = {};
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kCompareVersionsPrefsKey);
    var versions = <_CompareVersion>[];
    if (raw != null && raw.isNotEmpty) {
      versions = raw
          .map((s) {
            try {
              return _CompareVersion.fromJson(
                  jsonDecode(s) as Map<String, dynamic>);
            } catch (_) {
              return null;
            }
          })
          .whereType<_CompareVersion>()
          .where((v) => v.id.isNotEmpty)
          .toList();
    }
    // First time comparing anything: seed the list with whatever version the
    // reader is currently reading in, so the sheet isn't empty.
    if (versions.isEmpty &&
        (widget.currentBibleId ?? '').isNotEmpty) {
      versions = [
        _CompareVersion(
          id: widget.currentBibleId!,
          abbreviation: widget.currentVersionAbbrev ?? '',
          name: widget.currentVersionAbbrev ?? '',
        ),
      ];
    }
    if (!mounted) return;
    setState(() => _versions = versions);
    for (final v in versions) {
      _fetchVerseText(v);
    }
  }

  Future<void> _saveVersions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kCompareVersionsPrefsKey,
      _versions.map((v) => jsonEncode(v.toJson())).toList(),
    );
  }

  Future<void> _fetchVerseText(_CompareVersion version) async {
    if (!mounted) return;
    setState(() {
      _loading[version.id] = true;
      _errors.remove(version.id);
    });
    try {
      final verseId = '${widget.chapterId}.${widget.verseNumber}';
      final response = await BibleAPIGroup.verseCall.call(
        bibleID: version.id,
        verseID: verseId,
      );
      if (!response.succeeded) {
        throw Exception('request failed');
      }
      final content = BibleAPIGroup.verseCall.content(response.jsonBody) ?? '';
      final text = _extractVerseText(content);
      if (!mounted) return;
      setState(() {
        _verseText[version.id] =
            text.isEmpty ? 'No text available for this verse.' : text;
        _loading[version.id] = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errors[version.id] =
            'Couldn\'t load this verse in ${version.abbreviation.isNotEmpty ? version.abbreviation : version.name}.';
        _loading[version.id] = false;
      });
    }
  }

  Future<void> _openAddVersionPicker() async {
    final selected = await showModalBottomSheet<_CompareVersion>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.8,
          child: _AddCompareVersionSheet(
            excludeIds: _versions.map((v) => v.id).toSet(),
          ),
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _versions = [..._versions, selected]);
    _saveVersions();
    _fetchVerseText(selected);
  }

  void _removeVersion(int index) {
    setState(() => _versions.removeAt(index));
    _saveVersions();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final tileBg = isDark ? const Color(0xFF262629) : const Color(0xFFECECEC);
    final primary = FlutterFlowTheme.of(context).primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Compare ${widget.reference}:${widget.verseNumber}',
                style: GoogleFonts.interTight(
                  color: textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (_versions.isNotEmpty)
              GlassButton.custom(
                onTap: () => setState(() => _editMode = !_editMode),
                useOwnLayer: true,
                quality: GlassQuality.standard,
                height: 34.0,
                shape: const LiquidRoundedRectangle(borderRadius: 17.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    _editMode ? 'Done' : 'Edit',
                    style: GoogleFonts.inter(
                      color: primary,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12.0),
        Expanded(
          child: _versions.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      'Add a version to start comparing this verse.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: secondaryTextColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  itemCount: _versions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                  itemBuilder: (context, index) {
                    final v = _versions[index];
                    final isLoading = _loading[v.id] == true;
                    final error = _errors[v.id];
                    final text = _verseText[v.id];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: tileBg,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v.abbreviation.isNotEmpty
                                      ? v.abbreviation
                                      : v.name,
                                  style: GoogleFonts.interTight(
                                    color: primary,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                if (isLoading)
                                  SizedBox(
                                    width: 16.0,
                                    height: 16.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        secondaryTextColor,
                                      ),
                                    ),
                                  )
                                else if (error != null)
                                  Text(
                                    error,
                                    style: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      fontSize: 13.0,
                                    ),
                                  )
                                else
                                  Text(
                                    text ?? '',
                                    style: GoogleFonts.notoSerif(
                                      color: textColor,
                                      fontSize: 14.0,
                                      height: 1.4,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_editMode) ...[
                            const SizedBox(width: 8.0),
                            InkWell(
                              onTap: () => _removeVersion(index),
                              borderRadius: BorderRadius.circular(20.0),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.remove_circle_rounded,
                                  color: Colors.redAccent,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 10.0),
        GlassButton.custom(
          onTap: _openAddVersionPicker,
          useOwnLayer: true,
          quality: GlassQuality.standard,
          width: double.infinity,
          height: 48.0,
          shape: const LiquidRoundedRectangle(borderRadius: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: primary, size: 20.0),
              const SizedBox(width: 8.0),
              Text(
                'Add version',
                style: GoogleFonts.inter(
                  color: primary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Version picker used by "Add version" — its own floating, rounded sheet
/// (matching the rest of the Bible feature's sheet chrome) since it's a
/// separate `showModalBottomSheet` launched from within the compare sheet
/// rather than content the caller wraps for it.
class _AddCompareVersionSheet extends StatefulWidget {
  const _AddCompareVersionSheet({required this.excludeIds});

  final Set<String> excludeIds;

  @override
  State<_AddCompareVersionSheet> createState() =>
      _AddCompareVersionSheetState();
}

class _AddCompareVersionSheetState extends State<_AddCompareVersionSheet> {
  final _searchController = TextEditingController();
  bool _loading = true;
  String? _error;
  List<_CompareVersion> _allVersions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await BibleAPIGroup.biblesCall.call();
      final data = BibleAPIGroup.biblesCall.data(response.jsonBody) ?? [];
      final versions = data
          .map((b) => _CompareVersion(
                id: getJsonField(b, r'''$.id''').toString(),
                abbreviation: getJsonField(b, r'''$.abbreviation''').toString(),
                name: getJsonField(b, r'''$.name''').toString(),
              ))
          .where((v) => v.id.isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _allVersions = versions;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Couldn\'t load Bible versions.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C1F) : Colors.white;
    final handleColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final searchFieldBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;
    final tileBg = isDark ? const Color(0xFF262629) : const Color(0xFFECECEC);

    final query = _searchController.text.trim().toLowerCase();
    final filtered = _allVersions.where((v) {
      if (widget.excludeIds.contains(v.id)) return false;
      if (query.isEmpty) return true;
      return v.name.toLowerCase().contains(query) ||
          v.abbreviation.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: handleColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              Text(
                'Add a version',
                style: GoogleFonts.interTight(
                  color: textColor,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search versions',
                  hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                  prefixIcon: Icon(Icons.search_rounded, color: secondaryTextColor),
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
              const SizedBox(height: 12.0),
              Expanded(
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Text(
                              _error!,
                              style: GoogleFonts.inter(
                                  color: secondaryTextColor, fontSize: 14.0),
                            ),
                          )
                        : filtered.isEmpty
                            ? Center(
                                child: Text(
                                  'No versions found.',
                                  style: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      fontSize: 14.0),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8.0),
                                itemBuilder: (context, index) {
                                  final v = filtered[index];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: () =>
                                        Navigator.of(context).pop(v),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14.0),
                                      decoration: BoxDecoration(
                                        color: tileBg,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Text(
                                              v.abbreviation,
                                              style: GoogleFonts.interTight(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Text(
                                              v.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                color: textColor,
                                                fontSize: 14.0,
                                              ),
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
          ),
        ),
      ),
    );
  }
}
