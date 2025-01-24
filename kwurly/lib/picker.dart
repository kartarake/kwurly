import 'package:kwurly/handle.dart';
import 'dart:math';

int nouns = 10;

List<String> pick() {
  int n = 10;
  List<int> fileindexes = List.generate(n, (index) => index+1);
  int fileindex = fileindexes[Random().nextInt(fileindexes.length)];

  Map<String, dynamic> data = load('data/nouns${fileindex}.json');

  List<String> nouns = [];
  for (int i = 0; i < 10; i++) {
    String noun = data['nouns'][Random().nextInt(data['nouns'].length)];
    nouns.add(noun);
  }
  
  return nouns;
}