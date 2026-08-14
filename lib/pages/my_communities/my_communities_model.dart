import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'my_communities_widget.dart' show MyCommunitiesWidget;
import 'package:flutter/material.dart';

class MyCommunitiesModel extends FlutterFlowModel<MyCommunitiesWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  CommunitiesRow? _newCommunity;
  set newCommunity(CommunitiesRow? value) {
    _newCommunity = value;
    debugLogWidgetClass(this);
  }

  CommunitiesRow? get newCommunity => _newCommunity;

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
        actionOutputs: {
          'newCommunity': debugSerializeParam(
            newCommunity,
            ParamType.SupabaseRow,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=MyCommunities',
            name: 'Communities',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=MyCommunities',
        searchReference:
            'reference=Og1NeUNvbW11bml0aWVzUAFaDU15Q29tbXVuaXRpZXM=',
        widgetClassName: 'MyCommunities',
      );
}
