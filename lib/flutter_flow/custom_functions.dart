import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

Color hexToColor(String hexValue) {
  hexValue = hexValue.replaceAll('#', '').toUpperCase();

  if (hexValue.length == 6) {
    hexValue = 'FF$hexValue';
  }
  return Color(int.parse(hexValue, radix: 16));
}

String? sanitiseBible(String bibleHTML) {
  return '<div class="scripture-styles"> ' +
      bibleHTML.replaceAll(r'\', '') +
      ' </div';
}
