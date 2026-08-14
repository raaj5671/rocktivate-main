import '/flutter_flow/flutter_flow_util.dart';
import 'post_images_widget.dart' show PostImagesWidget;
import 'package:flutter/material.dart';

class PostImagesModel extends FlutterFlowModel<PostImagesWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

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
          'images': debugSerializeParam(
            widget?.images,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=PostImages',
            searchReference:
                'reference=ShoKEAoGaW1hZ2VzEgY3dzZzdWxyBhICCAQgAVAAWgZpbWFnZXM=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'pageViewCurrentIndex': debugSerializeParam(
            pageViewCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=PostImages',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=PostImages',
        searchReference: 'reference=OgpQb3N0SW1hZ2VzUABaClBvc3RJbWFnZXM=',
        widgetClassName: 'PostImages',
      );
}
