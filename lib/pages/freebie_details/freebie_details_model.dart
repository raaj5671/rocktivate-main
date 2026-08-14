import '/flutter_flow/flutter_flow_util.dart';
import 'freebie_details_widget.dart' show FreebieDetailsWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FreebieDetailsModel extends FlutterFlowModel<FreebieDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int _carouselCurrentIndex = 1;
  set carouselCurrentIndex(int value) {
    _carouselCurrentIndex = value;
    debugLogWidgetClass(this);
  }

  int get carouselCurrentIndex => _carouselCurrentIndex;

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
          'freebieLink': debugSerializeParam(
            widget?.freebieLink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieDetails',
            searchReference:
                'reference=ShsKFQoLZnJlZWJpZUxpbmsSBnd3NDF5OXICCANQAVoLZnJlZWJpZUxpbms=',
            name: 'String',
            nullable: true,
          ),
          'name': debugSerializeParam(
            widget?.name,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieDetails',
            searchReference:
                'reference=ShYKDgoEbmFtZRIGODVvdmcwcgQIAyABUAFaBG5hbWU=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'carouselCurrentIndex': debugSerializeParam(
            carouselCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieDetails',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=FreebieDetails',
        searchReference:
            'reference=Og5GcmVlYmllRGV0YWlsc1ABWg5GcmVlYmllRGV0YWlscw==',
        widgetClassName: 'FreebieDetails',
      );
}
