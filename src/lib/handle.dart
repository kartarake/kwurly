import 'dart:convert';
import 'dart:io';

Map<String, dynamic> decode(String data) {
  return const JsonDecoder().convert(data);
}

List<dynamic> decodeArray(String data) {
  return const JsonDecoder().convert(data);
}

String encode(Map<String, dynamic> data) {
  return const JsonEncoder().convert(data);
}

void save (Map<String, dynamic> data, String path) {
  final file = File(path);
  file.writeAsStringSync(encode(data));
}

Map<String, dynamic> load (String path) {
  final file = File(path);
  return decode(file.readAsStringSync());
}

List<String> loadArray (String path) {
  final file = File(path);
  List<dynamic> dynamicList = decodeArray(file.readAsStringSync());
  List<String> stringList = dynamicList.map((item) => item.toString()).toList();
  return stringList;
}


List<String> listOutPaths() {
  Directory dir = Directory("./data/");
  List<FileSystemEntity> entities = dir.listSync();
  List<String> paths = entities
    .whereType<File>()
    .map((file) => file.path)
    .toList();
  paths.remove("./data/manager.py");
  paths.remove("./data/download.py");
  return paths;
}

List<String> listOutIdeaPaths() {
  Directory dir = Directory("./userdata/ideas/");
  List<FileSystemEntity> entities = dir.listSync();
  List<String> paths = entities
    .whereType<File>()
    .map((file) => file.path)
    .toList();
  return paths;
}