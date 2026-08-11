import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'create_new_need_widget.dart' show CreateNewNeedWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateNewNeedModel extends FlutterFlowModel<CreateNewNeedWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Need_Title widget.
  FocusNode? needTitleFocusNode;
  TextEditingController? needTitleTextController;
  String? Function(BuildContext, String?)? needTitleTextControllerValidator;
  // State field(s) for Need_Desc widget.
  FocusNode? needDescFocusNode;
  TextEditingController? needDescTextController;
  String? Function(BuildContext, String?)? needDescTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    needTitleFocusNode?.dispose();
    needTitleTextController?.dispose();

    needDescFocusNode?.dispose();
    needDescTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'needTitleText': debugSerializeParam(
            needTitleTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CreateNewNeed',
            name: 'String',
            nullable: true,
          ),
          'needDescText': debugSerializeParam(
            needDescTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CreateNewNeed',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=CreateNewNeed',
        searchReference:
            'reference=Og1DcmVhdGVOZXdOZWVkUABaDUNyZWF0ZU5ld05lZWQ=',
        widgetClassName: 'CreateNewNeed',
      );
}
