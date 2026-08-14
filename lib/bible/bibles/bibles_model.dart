import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'bibles_widget.dart' show BiblesWidget;
import 'package:flutter/material.dart';

class BiblesModel extends FlutterFlowModel<BiblesWidget> {
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Bibles',
        searchReference: 'reference=OgZCaWJsZXNQAVoGQmlibGVz',
        widgetClassName: 'Bibles',
      );
}
