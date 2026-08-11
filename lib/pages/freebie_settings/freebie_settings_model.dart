import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'freebie_settings_widget.dart' show FreebieSettingsWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FreebieSettingsModel extends FlutterFlowModel<FreebieSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField_Title widget.
  FocusNode? textFieldTitleFocusNode;
  TextEditingController? textFieldTitleTextController;
  String? Function(BuildContext, String?)?
      textFieldTitleTextControllerValidator;
  // State field(s) for TextField_Description widget.
  FocusNode? textFieldDescriptionFocusNode;
  TextEditingController? textFieldDescriptionTextController;
  String? Function(BuildContext, String?)?
      textFieldDescriptionTextControllerValidator;
  // State field(s) for Switch widget.
  bool? _switchValue;
  set switchValue(bool? value) {
    _switchValue = value;
    debugLogWidgetClass(this);
  }

  bool? get switchValue => _switchValue;

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int _carouselCurrentIndex = 1;
  set carouselCurrentIndex(int value) {
    _carouselCurrentIndex = value;
    debugLogWidgetClass(this);
  }

  int get carouselCurrentIndex => _carouselCurrentIndex;

  bool isDataUploading_uploadDataFreebie = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadDataFreebie = [];
  List<String> uploadedFileUrls_uploadDataFreebie = [];

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    textFieldTitleFocusNode?.dispose();
    textFieldTitleTextController?.dispose();

    textFieldDescriptionFocusNode?.dispose();
    textFieldDescriptionTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'freebieLink': debugSerializeParam(
            widget?.freebieLink,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
            searchReference:
                'reference=ShsKFQoLZnJlZWJpZUxpbmsSBnd3NDF5OXICCANQAVoLZnJlZWJpZUxpbms=',
            name: 'String',
            nullable: true,
          ),
          'name': debugSerializeParam(
            widget?.name,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
            searchReference:
                'reference=ShYKDgoEbmFtZRIGODVvdmcwcgQIAyABUAFaBG5hbWU=',
            name: 'String',
            nullable: true,
          )
        }.withoutNulls,
        widgetStates: {
          'textFieldTitleText': debugSerializeParam(
            textFieldTitleTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
            name: 'String',
            nullable: true,
          ),
          'textFieldDescriptionText': debugSerializeParam(
            textFieldDescriptionTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
            name: 'String',
            nullable: true,
          ),
          'switchValue': debugSerializeParam(
            switchValue,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
            name: 'bool',
            nullable: true,
          ),
          'carouselCurrentIndex': debugSerializeParam(
            carouselCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=FreebieSettings',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=FreebieSettings',
        searchReference:
            'reference=Og9GcmVlYmllU2V0dGluZ3NQAVoPRnJlZWJpZVNldHRpbmdz',
        widgetClassName: 'FreebieSettings',
      );
}
