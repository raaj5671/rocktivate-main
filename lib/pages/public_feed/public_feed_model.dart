import '/backend/supabase/supabase.dart';
import '/components/post_images_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'public_feed_widget.dart' show PublicFeedWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PublicFeedModel extends FlutterFlowModel<PublicFeedWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for PostImages component.
  late PostImagesModel postImagesModel1;
  bool isDataUploading_uploadDataUpq = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadDataUpq = [];
  List<String> uploadedFileUrls_uploadDataUpq = [];

  // Models for PostImages dynamic component.
  Map<String, FlutterFlowModel> postImagesModels2 = {};

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    postImagesModel1 = createModel(context, () => PostImagesModel());

    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    postImagesModel1.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'textFieldText': debugSerializeParam(
            textController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=PublicFeed',
            name: 'String',
            nullable: true,
          )
        },
        generatorVariables: debugGeneratorVariables,
        backendQueries: debugBackendQueries,
        componentStates: {
          'postImagesModel1 (PostImages)':
              postImagesModel1.toWidgetClassDebugData(),
          ...widgetBuilderComponents.map(
            (key, value) => MapEntry(
              key,
              value.toWidgetClassDebugData(),
            ),
          ),
        }.withoutNulls,
        dynamicComponentStates: {
          'postImagesModels2 (List<PostImages>)': DynamicWidgetClassDebugData(
            componentStates: Map.fromIterables(
              List.generate(postImagesModels2.length, (index) => '[$index]'),
              postImagesModels2.values.map((e) => e.toWidgetClassDebugData()),
            ),
          ),
        }.withoutNulls,
        link:
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=PublicFeed',
        searchReference: 'reference=OgpQdWJsaWNGZWVkUAFaClB1YmxpY0ZlZWQ=',
        widgetClassName: 'PublicFeed',
      );
}
