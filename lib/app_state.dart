import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _HasCompletedOnboarding =
          prefs.getBool('ff_HasCompletedOnboarding') ?? _HasCompletedOnboarding;
    });
    _safeInit(() {
      _LoggedInUserUUID =
          prefs.getString('ff_LoggedInUserUUID') ?? _LoggedInUserUUID;
    });
    _safeInit(() {
      _LoggedInUserFullName =
          prefs.getString('ff_LoggedInUserFullName') ?? _LoggedInUserFullName;
    });
    _safeInit(() {
      _LoggedInUserDP = prefs.getString('ff_LoggedInUserDP') ?? _LoggedInUserDP;
    });
    _safeInit(() {
      _LoggedInUserProfilePic = prefs.getString('ff_LoggedInUserProfilePic') ??
          _LoggedInUserProfilePic;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _HasCompletedOnboarding = true;
  bool get HasCompletedOnboarding => _HasCompletedOnboarding;
  set HasCompletedOnboarding(bool value) {
    _HasCompletedOnboarding = value;
    prefs.setBool('ff_HasCompletedOnboarding', value);
    debugLogAppState(this);
  }

  String _LoggedInUserUUID = '';
  String get LoggedInUserUUID => _LoggedInUserUUID;
  set LoggedInUserUUID(String value) {
    _LoggedInUserUUID = value;
    prefs.setString('ff_LoggedInUserUUID', value);
    debugLogAppState(this);
  }

  String _LoggedInUserFullName = '';
  String get LoggedInUserFullName => _LoggedInUserFullName;
  set LoggedInUserFullName(String value) {
    _LoggedInUserFullName = value;
    prefs.setString('ff_LoggedInUserFullName', value);
    debugLogAppState(this);
  }

  String _LoggedInUserDP = '';
  String get LoggedInUserDP => _LoggedInUserDP;
  set LoggedInUserDP(String value) {
    _LoggedInUserDP = value;
    prefs.setString('ff_LoggedInUserDP', value);
    debugLogAppState(this);
  }

  String _LoggedInUserProfilePic = '';
  String get LoggedInUserProfilePic => _LoggedInUserProfilePic;
  set LoggedInUserProfilePic(String value) {
    _LoggedInUserProfilePic = value;
    prefs.setString('ff_LoggedInUserProfilePic', value);
    debugLogAppState(this);
  }

  Map<String, DebugDataField> toDebugSerializableMap() => {
        'HasCompletedOnboarding': debugSerializeParam(
          HasCompletedOnboarding,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CioKIgoWSGFzQ29tcGxldGVkT25ib2FyZGluZxIIdjV6eGxoczVyAggFegBaFkhhc0NvbXBsZXRlZE9uYm9hcmRpbmc=',
          name: 'bool',
          nullable: false,
        ),
        'LoggedInUserUUID': debugSerializeParam(
          LoggedInUserUUID,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiQKHAoQTG9nZ2VkSW5Vc2VyVVVJRBIIbGN0ZWlyemtyAggDegBaEExvZ2dlZEluVXNlclVVSUQ=',
          name: 'String',
          nullable: false,
        ),
        'LoggedInUserFullName': debugSerializeParam(
          LoggedInUserFullName,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CigKIAoUTG9nZ2VkSW5Vc2VyRnVsbE5hbWUSCHowOTJmenIwcgIIA3oAWhRMb2dnZWRJblVzZXJGdWxsTmFtZQ==',
          name: 'String',
          nullable: false,
        ),
        'LoggedInUserDP': debugSerializeParam(
          LoggedInUserDP,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiIKGgoOTG9nZ2VkSW5Vc2VyRFASCDJxbGRwcHJ0cgIIA3oAWg5Mb2dnZWRJblVzZXJEUA==',
          name: 'String',
          nullable: false,
        ),
        'LoggedInUserProfilePic': debugSerializeParam(
          LoggedInUserProfilePic,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CioKIgoWTG9nZ2VkSW5Vc2VyUHJvZmlsZVBpYxIIczhtdXF3NTNyAggEegBaFkxvZ2dlZEluVXNlclByb2ZpbGVQaWM=',
          name: 'String',
          nullable: false,
        )
      };
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
