import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

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
      params: {},
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

/// End Bible API Group Code

class ChatGPTCall {
  static Future<ApiCallResponse> call({
    String? userPrompt = '',
  }) async {
    final ffApiRequestBody = '''
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant. You must always respond as a bible scholor with helpful biblically corrrect and thologically correct information"
    },
    {
      "role": "user",
      "content": "${escapeStringForJson(userPrompt)}"
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ChatGPT',
      apiUrl: 'https://api.openai.com/v1/chat/completions',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer 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',
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
        r'''$.choices[:].message.content''',
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
