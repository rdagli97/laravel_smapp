import 'dart:convert';
import 'dart:io';

String? getStringImage(File? file) {
  if (file == null) return null;

  return base64Encode(file.readAsBytesSync());
}
