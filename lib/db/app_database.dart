import 'package:drift/drift.dart';
import 'package:redux_todo_app/db/connection/connection.dart' as impl;
import 'package:redux_todo_app/db/todo_table.dart';
import 'package:redux_todo_app/helper/extensions/todo_table.dart';
import 'package:redux_todo_app/models/models.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// Database class for the app.
/// {@endtemplate}
@DriftDatabase(tables: [Todos])
final class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase() : super(impl.connect());
  @override
  int get schemaVersion => 1;

  Future<List<TodoTable>> get all => select(todos).get();

  /// Add [Todo] to [AppDatabase]
  Future<TodoTable?> add(Todo todo) => into(todos).insertReturningOrNull(
        TodosCompanion(
          title: Value(todo.title),
          description: Value(todo.description),
          isCompleted: Value(todo.isCompleted),
        ),
        mode: InsertMode.insertOrRollback,
      );

  /// Toggle [Todo.isCompleted] property of [Todo] in [AppDatabase].
  Future<TodoTable?> toggleTaskCompletion(Todo todo) async {
    if (todo.id == null) return null;

    final updateStatement =
        (update(todos)..where((row) => row.id.equals(todo.id!)));

    return (await updateStatement.writeReturning(
      TodoTableExtension.fromTodoModel(
        todo.copyWith(isCompleted: !todo.isCompleted),
      ),
    ))
        .singleOrNull;
  }

  /// Remove [Todo] from [AppDatabase]
  Future<TodoTable?> remove(Todo todo) => delete(todos).deleteReturning(
        TodosCompanion(
          id: Value(todo.id),
        ),
      );
}
