import '/flutter_flow/flutter_flow_util.dart';
import 'login_director_widget.dart' show LoginDirectorWidget;
import 'package:flutter/material.dart';

class LoginDirectorModel extends FlutterFlowModel<LoginDirectorWidget> {
  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {}

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=LoginDirector',
        searchReference:
            'reference=Og1Mb2dpbkRpcmVjdG9yUAFaDUxvZ2luRGlyZWN0b3I=',
        widgetClassName: 'LoginDirector',
      );
}
