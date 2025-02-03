import 'dart:io';

import 'package:kwurly/handle.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

void saveIdea(String ideaTrack, String idea) {
  String ideaTrackHash = hash(ideaTrack);
  String filepath = "userdata/ideas/$ideaTrackHash.json";

  try {
    Map<String, dynamic> data = load(filepath);
    data["idea"] = idea;
    save(data, filepath);
    
  } on FileSystemException catch (e) {
    if (e.osError != null && e.osError!.errorCode == 2) {
      createfolder("userdata/ideas/");
      Map<String, dynamic> data = newformatData(idea, ideaTrack);      
      save(data, filepath);
    }
  }
}

Map<String, dynamic> newformatData (String idea, String ideatrack) {
  Map<String, dynamic> data = {};
  
  data["idea"] = idea;
  data["starred"] = false;
  data["ideatrack"] = ideatrack;

  return data;
}

void createfolder (String folderPath) {
  final directory = Directory(folderPath);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}

String hash(String input) {
  List<int> bytes = utf8.encode(input);
  Digest digest = sha256.convert(bytes);
  return digest.toString();
}