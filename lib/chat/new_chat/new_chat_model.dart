import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'new_chat_widget.dart' show NewChatWidget;
import 'package:flutter/material.dart';

class NewChatModel extends FlutterFlowModel<NewChatWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField_AIQuestion widget.
  FocusNode? textFieldAIQuestionFocusNode;
  TextEditingController? textFieldAIQuestionTextController;
  String? Function(BuildContext, String?)?
      textFieldAIQuestionTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    textFieldAIQuestionFocusNode?.dispose();
    textFieldAIQuestionTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'textFieldAIQuestionText': debugSerializeParam(
            textFieldAIQuestionTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=NewChat',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=NewChat',
        searchReference: 'reference=OgdOZXdDaGF0UAFaB05ld0NoYXQ=',
        widgetClassName: 'NewChat',
      );
}
