import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'onboard_widget.dart' show OnboardWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardModel extends FlutterFlowModel<OnboardWidget> {
  ///  Local state fields for this page.

  bool _giftWorship = false;
  set giftWorship(bool value) {
    _giftWorship = value;
    debugLogWidgetClass(this);
  }

  bool get giftWorship => _giftWorship;

  bool _giftProphesy = false;
  set giftProphesy(bool value) {
    _giftProphesy = value;
    debugLogWidgetClass(this);
  }

  bool get giftProphesy => _giftProphesy;

  bool _giftHealing = false;
  set giftHealing(bool value) {
    _giftHealing = value;
    debugLogWidgetClass(this);
  }

  bool get giftHealing => _giftHealing;

  bool _giftPreaching = false;
  set giftPreaching(bool value) {
    _giftPreaching = value;
    debugLogWidgetClass(this);
  }

  bool get giftPreaching => _giftPreaching;

  bool _giftTongues = false;
  set giftTongues(bool value) {
    _giftTongues = value;
    debugLogWidgetClass(this);
  }

  bool get giftTongues => _giftTongues;

  bool _giftOther = false;
  set giftOther(bool value) {
    _giftOther = value;
    debugLogWidgetClass(this);
  }

  bool get giftOther => _giftOther;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for TextField_FirstName widget.
  FocusNode? textFieldFirstNameFocusNode;
  TextEditingController? textFieldFirstNameTextController;
  String? Function(BuildContext, String?)?
      textFieldFirstNameTextControllerValidator;
  // State field(s) for TextField_LastName widget.
  FocusNode? textFieldLastNameFocusNode;
  TextEditingController? textFieldLastNameTextController;
  String? Function(BuildContext, String?)?
      textFieldLastNameTextControllerValidator;
  // State field(s) for DropDown widget.
  String? _dropDownValue;
  set dropDownValue(String? value) {
    _dropDownValue = value;
    debugLogWidgetClass(this);
  }

  String? get dropDownValue => _dropDownValue;

  FormFieldController<String>? dropDownValueController;
  DateTime? datePicked;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) {
    choiceChipsValueController?.value = val;
    debugLogWidgetClass(this);
  }

  // State field(s) for TextField_Country widget.
  FocusNode? textFieldCountryFocusNode;
  TextEditingController? textFieldCountryTextController;
  String? Function(BuildContext, String?)?
      textFieldCountryTextControllerValidator;
  // State field(s) for TextField_PostCode widget.
  FocusNode? textFieldPostCodeFocusNode;
  TextEditingController? textFieldPostCodeTextController;
  String? Function(BuildContext, String?)?
      textFieldPostCodeTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    textFieldFirstNameFocusNode?.dispose();
    textFieldFirstNameTextController?.dispose();

    textFieldLastNameFocusNode?.dispose();
    textFieldLastNameTextController?.dispose();

    textFieldCountryFocusNode?.dispose();
    textFieldCountryTextController?.dispose();

    textFieldPostCodeFocusNode?.dispose();
    textFieldPostCodeTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        localStates: {
          'giftWorship': debugSerializeParam(
            giftWorship,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QiUKFAoLZ2lmdFdvcnNoaXASBWpoeHpvKgcSBWZhbHNlcgQIBSABUAFaC2dpZnRXb3JzaGlwYgdPbmJvYXJk',
            name: 'bool',
            nullable: false,
          ),
          'giftProphesy': debugSerializeParam(
            giftProphesy,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QiYKFQoMZ2lmdFByb3BoZXN5EgU5YWRiMioHEgVmYWxzZXIECAUgAVABWgxnaWZ0UHJvcGhlc3liB09uYm9hcmQ=',
            name: 'bool',
            nullable: false,
          ),
          'giftHealing': debugSerializeParam(
            giftHealing,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QiUKFAoLZ2lmdEhlYWxpbmcSBW1nc3Y0KgcSBWZhbHNlcgQIBSABUAFaC2dpZnRIZWFsaW5nYgdPbmJvYXJk',
            name: 'bool',
            nullable: false,
          ),
          'giftPreaching': debugSerializeParam(
            giftPreaching,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QicKFgoNZ2lmdFByZWFjaGluZxIFbXA3NzQqBxIFZmFsc2VyBAgFIAFQAVoNZ2lmdFByZWFjaGluZ2IHT25ib2FyZA==',
            name: 'bool',
            nullable: false,
          ),
          'giftTongues': debugSerializeParam(
            giftTongues,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QiUKFAoLZ2lmdFRvbmd1ZXMSBTJzbjl6KgcSBWZhbHNlcgQIBSABUAFaC2dpZnRUb25ndWVzYgdPbmJvYXJk',
            name: 'bool',
            nullable: false,
          ),
          'giftOther': debugSerializeParam(
            giftOther,
            ParamType.bool,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            searchReference:
                'reference=QiMKEgoJZ2lmdE90aGVyEgVudnpjZCoHEgVmYWxzZXIECAUgAVABWglnaWZ0T3RoZXJiB09uYm9hcmQ=',
            name: 'bool',
            nullable: false,
          )
        },
        widgetStates: {
          'pageViewCurrentIndex': debugSerializeParam(
            pageViewCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'int',
            nullable: true,
          ),
          'textFieldFirstNameText': debugSerializeParam(
            textFieldFirstNameTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'String',
            nullable: true,
          ),
          'textFieldLastNameText': debugSerializeParam(
            textFieldLastNameTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'String',
            nullable: true,
          ),
          'dropDownValue': debugSerializeParam(
            dropDownValue,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'String',
            nullable: true,
          ),
          'choiceChipsValues': debugSerializeParam(
            choiceChipsValues,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'String',
            nullable: true,
          ),
          'textFieldCountryText': debugSerializeParam(
            textFieldCountryTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
            name: 'String',
            nullable: true,
          ),
          'textFieldPostCodeText': debugSerializeParam(
            textFieldPostCodeTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboard',
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
        link:
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Onboard',
        searchReference: 'reference=OgdPbmJvYXJkUAFaB09uYm9hcmQ=',
        widgetClassName: 'Onboard',
      );
}
