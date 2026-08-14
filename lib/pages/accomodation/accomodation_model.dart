import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'accomodation_widget.dart' show AccomodationWidget;
import 'package:flutter/material.dart';

class AccomodationModel extends FlutterFlowModel<AccomodationWidget> {
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
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Accomodation',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Accomodation',
        searchReference: 'reference=OgxBY2NvbW9kYXRpb25QAVoMQWNjb21vZGF0aW9u',
        widgetClassName: 'Accomodation',
      );
}
