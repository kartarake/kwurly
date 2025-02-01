import 'dart:math';
import "dart:io";

String generateUniqueSequence() {
  // Define character pool for the sequence
  const String allowedCharacters = 
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      'abcdefghijklmnopqrstuvwxyz'
      '0123456789'
      '!@#\$%^&*()';

  final random = Random();
  final buffer = StringBuffer();

  // Generate 10 random characters
  for (int i = 0; i < 10; i++) {
    final randomIndex = random.nextInt(allowedCharacters.length);
    buffer.write(allowedCharacters[randomIndex]);
  }

  return buffer.toString();
}


/// Lists all files in a folder synchronously and returns their paths as a List<String>
List<String> listFilesInFolder(String folderPath) {
  final directory = Directory(folderPath);

  if (!directory.existsSync()) {
    throw Exception('Folder does not exist: $folderPath');
  }

  // List all entities in the directory synchronously
  final entities = directory.listSync();

  // Filter out only files (exclude subdirectories) and return their paths
  final files = entities
      .where((entity) => entity is File) // Check if the entity is a file
      .map((entity) => entity.path)      // Get the file path as a String
      .toList();

  return files;
}


Future<void> createFolderIfNotExists(String folderPath) async {
  final directory = Directory(folderPath);

  if (!await directory.exists()) {;
    await directory.create(recursive: true); // Create folder and parent directories if needed
  } else {
    return;
  }
}