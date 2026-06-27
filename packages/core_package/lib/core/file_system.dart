import 'dart:io';

/// Utilidades para operaciones del sistema de archivos.
class FileSystem {
  /// Crea la estructura de directorios completa para un path.
  Future<void> createDirectories(String path) async {
    final directory = Directory(path);
    await directory.create(recursive: true);
  }

  /// Escribe contenido en un archivo, creando los directorios padre si no existen.
  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  /// Lee el contenido de un archivo como String.
  Future<String> readFile(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  /// Verifica si un archivo o directorio existe.
  bool exists(String path) {
    return FileSystemEntity.isFileSync(path) ||
        FileSystemEntity.isDirectorySync(path);
  }

  /// Copia un archivo de origen a destino.
  Future<void> copyFile(String source, String destination) async {
    final sourceFile = File(source);
    final destFile = File(destination);
    await destFile.parent.create(recursive: true);
    await sourceFile.copy(destination);
  }
}
