import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
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
  // State field(s) for DropDown_Gender widget.
  String? _dropDownGenderValue;
  set dropDownGenderValue(String? value) {
    _dropDownGenderValue = value;
    debugLogWidgetClass(this);
  }

  String? get dropDownGenderValue => _dropDownGenderValue;

  FormFieldController<String>? dropDownGenderValueController;
  DateTime? datePicked;
  // State field(s) for DropDown widget.
  String? _dropDownValue;
  set dropDownValue(String? value) {
    _dropDownValue = value;
    debugLogWidgetClass(this);
  }

  String? get dropDownValue => _dropDownValue;

  FormFieldController<String>? dropDownValueController;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) {
    choiceChipsValueController?.value = val;
    debugLogWidgetClass(this);
  }

  // State field(s) for DropDow_Country widget.
  String? _dropDowCountryValue;
  set dropDowCountryValue(String? value) {
    _dropDowCountryValue = value;
    debugLogWidgetClass(this);
  }

  String? get dropDowCountryValue => _dropDowCountryValue;

  FormFieldController<String>? dropDowCountryValueController;
  // State field(s) for TextField_PostCode widget.
  FocusNode? textFieldPostCodeFocusNode;
  TextEditingController? textFieldPostCodeTextController;
  String? Function(BuildContext, String?)?
      textFieldPostCodeTextControllerValidator;
  bool isDataUploading_uploadDataGt2 = false;
  FFUploadedFile uploadedLocalFile_uploadDataGt2 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataGt2 = '';

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<PeopleRow>? _updatedUserData;
  set updatedUserData(List<PeopleRow>? value) {
    _updatedUserData = value;
    debugLogWidgetClass(this);
  }

  List<PeopleRow>? get updatedUserData => _updatedUserData;

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

    textFieldPostCodeFocusNode?.dispose();
    textFieldPostCodeTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'pageViewCurrentIndex': debugSerializeParam(
            pageViewCurrentIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'int',
            nullable: true,
          ),
          'textFieldFirstNameText': debugSerializeParam(
            textFieldFirstNameTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'textFieldLastNameText': debugSerializeParam(
            textFieldLastNameTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'dropDownGenderValue': debugSerializeParam(
            dropDownGenderValue,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'dropDownValue': debugSerializeParam(
            dropDownValue,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'choiceChipsValues': debugSerializeParam(
            choiceChipsValues,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'dropDowCountryValue': debugSerializeParam(
            dropDowCountryValue,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          ),
          'textFieldPostCodeText': debugSerializeParam(
            textFieldPostCodeTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'String',
            nullable: true,
          )
        },
        actionOutputs: {
          'updatedUserData': debugSerializeParam(
            updatedUserData,
            ParamType.SupabaseRow,
            isList: true,
            link:
                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Onboarding',
            name: 'People',
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
            'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn/tab=uiBuilder&page=Onboarding',
        searchReference: 'reference=OgpPbmJvYXJkaW5nUAFaCk9uYm9hcmRpbmc=',
        widgetClassName: 'Onboarding',
      );
}
