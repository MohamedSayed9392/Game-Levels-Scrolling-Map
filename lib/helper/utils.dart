
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class Utils {

  static Future<String> readFile(String filePath, {isTest = false}) async {
    return isTest || !filePath.contains("assets")
        ? File(filePath).readAsString()
        : rootBundle.loadString(filePath);
  }

  // How I read SVG files
  static Future<XmlDocument> readSvg(String filePath, {isTest = false}) async {
    String path = filePath;
    if(filePath.contains("http")){
      path = await downloadFile(filePath);
    }
    var content = await readFile(path, isTest: isTest);
    var xmlRoot = XmlDocument.parse(content);
    return xmlRoot;
  }

  static Future<String> downloadFile(String url) async{
    final request = await HttpClient().getUrl(Uri.parse(url));

    final response = await request.close();
    Directory tempDir = await getTemporaryDirectory();
    String path = "${tempDir.path}/temp_file";
    await response.pipe(File(path).openWrite());
    return path;
  }

// How I filter out specific elements
  static Iterable<XmlElement> getXmlWithClass(XmlDocument root, String classId) {
    return root.descendants
        .whereType<XmlElement>()
        .where((p) => p.getAttribute('class') == classId)
        .toList();
  }

  static List<Offset> pathToCoords(Path path, [double pixelGap = 2]) {
    var metrics = path.computeMetrics();
    if (metrics.isEmpty) return [];

    var coords = <Offset>[];
    var metric = path.computeMetrics().first;

    double position = 0;
    while (position < metric.length) {
      var tangent = metric.getTangentForOffset(position);
      coords.add(tangent!.position);
      position += pixelGap;
    }

    return coords;
  }
}
