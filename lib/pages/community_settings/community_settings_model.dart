import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'community_settings_widget.dart' show CommunitySettingsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommunitySettingsModel extends FlutterFlowModel<CommunitySettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Switch widget.
  bool? _switchValue;
  set switchValue(bool? value) {
    _switchValue = value;
    debugLogWidgetClass(this);
  }

  bool? get switchValue => _switchValue;

  bool isDataUploading_uploadDataAdv = false;
  FFUploadedFile uploadedLocalFile_uploadDataAdv =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataAdv = '';

  bool isDataUploading_uploadDataAde = false;
  FFUploadedFile uploadedLocalFile_uploadDataAde =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataAde = '';

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'groupLink': debugSerializeParam(
            widget?.groupLink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunitySettings',
            searchReference:
                'reference=ShkKEwoJZ3JvdXBMaW5rEgZ3dzQxeTlyAggDUAFaCWdyb3VwTGluaw==',
            name: 'String',
            nullable: true,
          ),
          'name': debugSerializeParam(
            widget?.name,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunitySettings',
            searchReference:
                'reference=ShYKDgoEbmFtZRIGODVvdmcwcgQIAyABUAFaBG5hbWU=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'textFieldText': debugSerializeParam(
            textController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunitySettings',
            name: 'String',
            nullable: true,
          ),
          'switchValue': debugSerializeParam(
            switchValue,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunitySettings',
            name: 'bool',
            nullable: true,
          )
        },
        generatorVariables: debugGeneratorVariables,
        backendQueries: debugBackendQueries,
        componentStates: {
          ...widgetBuilderComponents.map(
            (key, value) => MapEntry(
              key,
              value.toWidgetClassDebugData(),
            ),
          ),
        }.withoutNulls,
        link:
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=CommunitySettings',
        searchReference:
            'reference=OhFDb21tdW5pdHlTZXR0aW5nc1ABWhFDb21tdW5pdHlTZXR0aW5ncw==',
        widgetClassName: 'CommunitySettings',
      );
}
