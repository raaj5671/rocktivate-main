import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'a_i_response_widget.dart' show AIResponseWidget;
import 'package:flutter/material.dart';

class AIResponseModel extends FlutterFlowModel<AIResponseWidget> {
  ///  Local state fields for this component.

  String _aPIResponse = 'Loading...';
  set aPIResponse(String value) {
    _aPIResponse = value;
    debugLogWidgetClass(this);
  }

  String get aPIResponse => _aPIResponse;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (ChatGPT)] action in AIResponse widget.
  ApiCallResponse? _chatGPTAPIResponse;
  set chatGPTAPIResponse(ApiCallResponse? value) {
    _chatGPTAPIResponse = value;
    debugLogWidgetClass(this);
  }

  ApiCallResponse? get chatGPTAPIResponse => _chatGPTAPIResponse;

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
          'question': debugSerializeParam(
            widget?.question,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=AIResponse',
            searchReference:
                'reference=ShoKEgoIcXVlc3Rpb24SBjNodWF4cHIECAMgAVAAWghxdWVzdGlvbg==',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        localStates: {
          'aPIResponse': debugSerializeParam(
            aPIResponse,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=AIResponse',
            searchReference:
                'reference=QiAKFAoLYVBJUmVzcG9uc2USBW5uZmU0KgISAHIECAMgAVAAWgthUElSZXNwb25zZWIKQUlSZXNwb25zZQ==',
            name: 'String',
            nullable: false,
          )
        },
        actionOutputs: {
          'chatGPTAPIResponse': debugSerializeParam(
            chatGPTAPIResponse,
            ParamType.ApiResponse,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=AIResponse',
            name: 'ApiCallResponse',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=AIResponse',
        searchReference: 'reference=OgpBSVJlc3BvbnNlUABaCkFJUmVzcG9uc2U=',
        widgetClassName: 'AIResponse',
      );
}
