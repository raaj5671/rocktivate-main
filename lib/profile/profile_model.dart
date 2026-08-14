import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  Local state fields for this page.

  bool _bioDisabled = true;
  set bioDisabled(bool value) {
    _bioDisabled = value;
    debugLogWidgetClass(this);
  }

  bool get bioDisabled => _bioDisabled;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

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
          'id': debugSerializeParam(
            widget?.id,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Profile',
            searchReference:
                'reference=ShQKDAoCaWQSBmNheDFjcnIECAMgAFABWgJpZA==',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        localStates: {
          'bioDisabled': debugSerializeParam(
            bioDisabled,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Profile',
            searchReference:
                'reference=QiUKFAoLYmlvRGlzYWJsZWQSBTZqeDZpKgcSBWZhbHNlcgQIBSABUAFaC2Jpb0Rpc2FibGVkYgdQcm9maWxl',
            name: 'bool',
            nullable: false,
          )
        },
        widgetStates: {
          'textFieldText': debugSerializeParam(
            textController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Profile',
            name: 'String',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Profile',
        searchReference: 'reference=OgdQcm9maWxlUAFaB1Byb2ZpbGU=',
        widgetClassName: 'Profile',
      );
}
