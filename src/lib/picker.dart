import 'package:kwurly/handle.dart';
import 'dart:math';
import 'dart:io';

int n = 10; // The number of words returned per call

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

List<String> pick() {
  List<String> paths = listOutPaths();
  Random random = Random();

  List<String> nouns = [];
  for (int i = 0; i < n; i++) {
    String path = paths[random.nextInt(paths.length)];
    List<String> data = loadArray(path);
    nouns.add(data[random.nextInt(data.length)]);
  }
  
  return nouns;
}