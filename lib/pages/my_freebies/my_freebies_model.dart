import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'my_freebies_widget.dart' show MyFreebiesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyFreebiesModel extends FlutterFlowModel<MyFreebiesWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  FreebiesRow? _newFreebie;
  set newFreebie(FreebiesRow? value) {
    _newFreebie = value;
    debugLogWidgetClass(this);
  }

  FreebiesRow? get newFreebie => _newFreebie;

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
        actionOutputs: {
          'newFreebie': debugSerializeParam(
            newFreebie,
            ParamType.SupabaseRow,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=MyFreebies',
            name: 'Freebies',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=MyFreebies',
        searchReference: 'reference=OgpNeUZyZWViaWVzUAFaCk15RnJlZWJpZXM=',
        widgetClassName: 'MyFreebies',
      );
}
