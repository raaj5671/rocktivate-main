import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'message_bubble_widget.dart' show MessageBubbleWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessageBubbleModel extends FlutterFlowModel<MessageBubbleWidget> {
  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'fromMe': debugSerializeParam(
            widget?.fromMe,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=MessageBubble',
            searchReference:
                'reference=SiEKEAoGZnJvbU1lEgZyNndjbmgqBxIFZmFsc2VyBAgFIAFQAFoGZnJvbU1l',
            name: 'bool',
            nullable: false,
          ),
          'messageBody': debugSerializeParam(
            widget?.messageBody,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=MessageBubble',
            searchReference:
                'reference=Sh0KFQoLbWVzc2FnZUJvZHkSBmdxdG92N3IECAMgAVAAWgttZXNzYWdlQm9keQ==',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=MessageBubble',
        searchReference:
            'reference=Og1NZXNzYWdlQnViYmxlUABaDU1lc3NhZ2VCdWJibGU=',
        widgetClassName: 'MessageBubble',
      );
}
