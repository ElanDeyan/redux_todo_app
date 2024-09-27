import 'package:drift/drift.dart';
import 'package:redux_todo_app/models/models.dart';

/// Drift's table for all [Todo]
@DataClassName('TodoTable')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
