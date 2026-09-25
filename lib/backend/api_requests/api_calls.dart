import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';
import 'api_secrets.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Bible API Group Code

class BibleAPIGroup {
  static String getBaseUrl() => 'https://rest.api.bible/v1/';
  static Map<String, String> headers = {};
  static BiblesCall biblesCall = BiblesCall();
  static BooksCall booksCall = BooksCall();
  static ChapterCall chapterCall = ChapterCall();
  static ChapterDataCall chapterDataCall = ChapterDataCall();
  static SearchCall searchCall = SearchCall();
  static VerseCall verseCall = VerseCall();
}

class BiblesCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Bibles',
      apiUrl: '${baseUrl}bibles',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {
        'language': "ENG",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? names(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? abreviation(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].abbreviation''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? bibleID(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class BooksCall {
  Future<ApiCallResponse> call({
    String? bibleID = '',
  }) async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Books',
      apiUrl: '${baseUrl}bibles/${bibleID}/books',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {
        'include-chapters': 'true',
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? bookName(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? bookLongName(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].nameLong''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? bookID(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class ChapterCall {
  Future<ApiCallResponse> call({
    String? bibleID = '',
    String? bookID = '',
  }) async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Chapter',
      apiUrl: '${baseUrl}bibles/${bibleID}/books/${bookID}/chapters',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? chapterNumber(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].number''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? chapterName(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].reference''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class ChapterDataCall {
  Future<ApiCallResponse> call({
    String? bibleID = '',
    String? chapterID = '',
  }) async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ChapterData',
      apiUrl: '${baseUrl}bibles/${bibleID}/chapters/${chapterID}',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? content(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.content''',
      ));
  String? chapterReference(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reference''',
      ));
  dynamic nextChapter(dynamic response) => getJsonField(
        response,
        r'''$.data.next''',
      );
  dynamic previousChapter(dynamic response) => getJsonField(
        response,
        r'''$.data.previous''',
      );
  String? copyright(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.copyright''',
      ));
  String? nextID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.next.id''',
      ));
  String? previousID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.previous.id''',
      ));
}

class SearchCall {
  Future<ApiCallResponse> call({
    String? bibleID = '',
    String? query = '',
  }) async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Search',
      apiUrl: '${baseUrl}bibles/${bibleID}/search',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {
        'query': query,
        'limit': '20',
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? verses(dynamic response) => getJsonField(
        response,
        r'''$.data.verses''',
        true,
      ) as List?;
}

class VerseCall {
  Future<ApiCallResponse> call({
    String? bibleID = '',
    String? verseID = '',
  }) async {
    final baseUrl = BibleAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Verse',
      apiUrl: '${baseUrl}bibles/${bibleID}/verses/${verseID}',
      callType: ApiCallType.GET,
      headers: {
        'api-key': 'QK2RbB3vPy_TIO7IhXuPf',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? content(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.content''',
      ));
  String? reference(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reference''',
      ));
}

/// End Bible API Group Code

// Despite the name (kept as-is so every call site — AIResponseWidget, the
// Bible feature's Ask AI / Compare actions — didn't need touching), this now
// calls Anthropic's Claude Messages API rather than OpenAI's.
class ChatGPTCall {
  static Future<ApiCallResponse> call({
    String? userPrompt = '',
    // Full multi-turn conversation as {'role': 'user'|'assistant', 'content':
    // text} entries. When provided, this replaces userPrompt entirely (lets
    // a chat UI send its whole history for follow-up context) — omit it for
    // the original single-question behavior.
    List<Map<String, String>>? history,
  }) async {
    final turns = history ??
        [
          {'role': 'user', 'content': userPrompt ?? ''}
        ];
    final messagesJson = turns
        .map((turn) => '{"role": "${turn['role']}", '
            '"content": "${escapeStringForJson(turn['content'])}"}')
        .join(',\n    ');
    final ffApiRequestBody = '''
{
  "model": "claude-haiku-4-5-20251001",
  "max_tokens": 1024,
  "system": "You are a helpful assistant. You must always respond as a bible scholor with helpful biblically corrrect and thologically correct information",
  "messages": [
    $messagesJson
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ChatGPT',
      apiUrl: 'https://api.anthropic.com/v1/messages',
      callType: ApiCallType.POST,
      headers: {
        'x-api-key': claudeApiKey,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? aIResponse(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.content[:].text''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
