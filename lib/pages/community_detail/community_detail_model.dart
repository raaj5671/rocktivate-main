import '/flutter_flow/flutter_flow_util.dart';
import 'community_detail_widget.dart' show CommunityDetailWidget;
import 'package:flutter/material.dart';

class CommunityDetailModel extends FlutterFlowModel<CommunityDetailWidget> {
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
        widgetParameters: {
          'groupLink': debugSerializeParam(
            widget?.groupLink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityDetail',
            searchReference:
                'reference=ShkKEwoJZ3JvdXBMaW5rEgZ3dzQxeTlyAggDUAFaCWdyb3VwTGluaw==',
            name: 'String',
            nullable: true,
          ),
          'name': debugSerializeParam(
            widget?.name,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=CommunityDetail',
            searchReference:
                'reference=ShYKDgoEbmFtZRIGODVvdmcwcgQIAyABUAFaBG5hbWU=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=CommunityDetail',
        searchReference:
            'reference=Og9Db21tdW5pdHlEZXRhaWxQAVoPQ29tbXVuaXR5RGV0YWls',
        widgetClassName: 'CommunityDetail',
      );
}
