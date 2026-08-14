import '/flutter_flow/flutter_flow_util.dart';
import 'chapter_data_widget.dart' show ChapterDataWidget;
import 'package:flutter/material.dart';

class ChapterDataModel extends FlutterFlowModel<ChapterDataWidget> {
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
          'title': debugSerializeParam(
            widget?.title,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=ChapterData',
            searchReference:
                'reference=SiAKDwoFdGl0bGUSBnpybmVnZyoHEgVCb29rc3IECAMgAVABWgV0aXRsZQ==',
            name: 'String',
            nullable: false,
          ),
          'bibleid': debugSerializeParam(
            widget?.bibleid,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=ChapterData',
            searchReference:
                'reference=ShkKEQoHYmlibGVpZBIGN3R4MmRscgQIAyABUAFaB2JpYmxlaWQ=',
            name: 'String',
            nullable: true,
          ),
          'chapterid': debugSerializeParam(
            widget?.chapterid,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=ChapterData',
            searchReference:
                'reference=ShsKEwoJY2hhcHRlcmlkEgZ3aHEzdHByBAgDIAFQAVoJY2hhcHRlcmlk',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=ChapterData',
        searchReference: 'reference=OgtDaGFwdGVyRGF0YVABWgtDaGFwdGVyRGF0YQ==',
        widgetClassName: 'ChapterData',
      );
}
