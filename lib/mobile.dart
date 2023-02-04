import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

Future<void> saveAndLaunchFile2(List<int> bytes, String fileName) async {
    // final path = (await getExternalStorageDirectory())!.path;
    // final file = File('$path/report.pdf');
    // await file.writeAsBytes(bytes, flush: true);
    // OpenFile.open('$path/report.pdf');
    AnchorElement(
        href:
        'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'report.pdf')
        ..click();
}