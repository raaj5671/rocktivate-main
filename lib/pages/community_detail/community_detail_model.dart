import '/backend/supabase/supabase.dart';
import '/components/new_group_post_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'community_detail_widget.dart' show CommunityDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

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
