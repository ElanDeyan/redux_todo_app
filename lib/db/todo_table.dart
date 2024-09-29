import 'package:drift/drift.dart';
import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/models/models.dart';

/// Drift's table for all [Todo]
@DataClassName('TodoTable')
class Todos extends Table {
  /// [Todo]'s id. Can be null when adding and the [AppDatabase] will
  /// give it.
  IntColumn get id => integer().autoIncrement().nullable()();

  /// [Todo]'s title.
  TextColumn get title => text().withLength(min: 1)();

  /// [Todo]'s description
  TextColumn get description => text().nullable()();

  /// [Todo]'s completion.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
