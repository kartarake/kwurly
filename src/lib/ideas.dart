import 'package:kwurly/handle.dart';
import "package:kwurly/utility.dart";

void saveIdea(idea) async{
  await createFolderIfNotExists("userdata/ideas");
  List<String> files = listFilesInFolder("userdata/ideas");

  Map<String, dynamic> data = {};
  data["idea"] = idea;
  data["date"] = DateTime.now().toString();
  data["star"] = false;
  data["words"] = [];

  String id = generateUniqueSequence();
  while (files.contains("userdata/ideas/$id.json")) {
    id = generateUniqueSequence();
  }
  save(data, "userdata/ideas/$id.json");
}