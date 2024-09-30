import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

/// Returns a [DatabaseConnection] for web platform.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(() async {
      final db = await WasmDatabase.open(
        databaseName: 'redux_todo_app',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (db.missingFeatures.isNotEmpty) {
        debugPrint(
          'Using ${db.chosenImplementation} due '
          'to unsupported features: ${db.missingFeatures}',
        );
      }

      return db.resolvedExecutor;
    }),
  );
}
