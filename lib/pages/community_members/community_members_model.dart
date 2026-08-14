import '/flutter_flow/flutter_flow_util.dart';
import 'community_members_widget.dart' show CommunityMembersWidget;
import 'package:flutter/material.dart';

class CommunityMembersModel extends FlutterFlowModel<CommunityMembersWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    tabBarController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'groupLink': debugSerializeParam(
            widget?.groupLink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityMembers',
            searchReference:
                'reference=ShkKEwoJZ3JvdXBMaW5rEgZ3dzQxeTlyAggDUAFaCWdyb3VwTGluaw==',
            name: 'String',
            nullable: true,
          ),
          'name': debugSerializeParam(
            widget?.name,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityMembers',
            searchReference:
                'reference=ShYKDgoEbmFtZRIGODVvdmcwcgQIAyABUAFaBG5hbWU=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'tabBarCurrentIndex': debugSerializeParam(
            tabBarCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityMembers',
            name: 'int',
            nullable: true,
          ),
          'tabBarPreviousIndex': debugSerializeParam(
            tabBarPreviousIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityMembers',
            name: 'int',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=CommunityMembers',
        searchReference:
            'reference=OhBDb21tdW5pdHlNZW1iZXJzUAFaEENvbW11bml0eU1lbWJlcnM=',
        widgetClassName: 'CommunityMembers',
      );
}
