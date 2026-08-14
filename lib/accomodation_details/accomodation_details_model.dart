import '/flutter_flow/flutter_flow_util.dart';
import 'accomodation_details_widget.dart' show AccomodationDetailsWidget;
import 'package:flutter/material.dart';

class AccomodationDetailsModel
    extends FlutterFlowModel<AccomodationDetailsWidget> {
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
          'proplink': debugSerializeParam(
            widget?.proplink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=AccomodationDetails',
            searchReference:
                'reference=ShoKEgoIcHJvcGxpbmsSBjUzZzNya3IECAMgAVABWghwcm9wbGluaw==',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=AccomodationDetails',
        searchReference:
            'reference=OhNBY2NvbW9kYXRpb25EZXRhaWxzUAFaE0FjY29tb2RhdGlvbkRldGFpbHM=',
        widgetClassName: 'AccomodationDetails',
      );
}
