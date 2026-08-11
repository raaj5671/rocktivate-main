import '/backend/supabase/supabase.dart';
import '/chat/message_bubble/message_bubble_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for MessageBubble dynamic component.
  Map<String, FlutterFlowModel> messageBubbleModels = {};
  // State field(s) for MessageBodyField widget.
  FocusNode? messageBodyFieldFocusNode;
  TextEditingController? messageBodyFieldTextController;
  String? Function(BuildContext, String?)?
      messageBodyFieldTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    messageBodyFieldFocusNode?.dispose();
    messageBodyFieldTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'id': debugSerializeParam(
            widget?.id,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chat',
            searchReference:
                'reference=ShQKDAoCaWQSBmlhYm5nNnIECAMgAVABWgJpZA==',
            name: 'String',
            nullable: true,
          ),
          'user': debugSerializeParam(
            widget?.user,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chat',
            searchReference:
                'reference=ShYKDgoEdXNlchIGbGZ5aHFmcgQIAyABUAFaBHVzZXI=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'messageBodyFieldText': debugSerializeParam(
            messageBodyFieldTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chat',
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
        dynamicComponentStates: {
          'messageBubbleModels (List<MessageBubble>)':
              DynamicWidgetClassDebugData(
            componentStates: Map.fromIterables(
              List.generate(messageBubbleModels.length, (index) => '[$index]'),
              messageBubbleModels.values.map((e) => e.toWidgetClassDebugData()),
            ),
          ),
        }.withoutNulls,
        link:
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Chat',
        searchReference: 'reference=OgRDaGF0UAFaBENoYXQ=',
        widgetClassName: 'Chat',
      );
}
