import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

Future<File> get _databaseFile async {
  final directory = await getApplicationDocumentsDirectory();

  final path = p.join(directory.path, 'redux_todo_app.db');

  return File(path);
}
/// Returns a [DatabaseConnection] for native platforms:
/// windows, android, iOS, MacOS, linux.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(
      () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          final cachebase = (await getTemporaryDirectory()).path;

          sqlite3.tempDirectory = cachebase;
        }

        return NativeDatabase.createBackgroundConnection(await _databaseFile);
      },
    ),
  );
}
