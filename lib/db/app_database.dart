import 'package:drift/drift.dart';
import 'package:redux_todo_app/db/connection/connection.dart' as impl;
import 'package:redux_todo_app/db/todo_table.dart';
import 'package:redux_todo_app/helper/extensions/todo_model_extension.dart';
import 'package:redux_todo_app/helper/extensions/todo_table_extension.dart';
import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// Database class for the app.
/// {@endtemplate}
@DriftDatabase(tables: [Todos])
final class AppDatabase extends _$AppDatabase implements TodosRepository {
  /// {@macro app_database}
  AppDatabase() : super(impl.connect());
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (to == 2) {
            await m.addColumn(todos, todos.createdAt);
          }
        },
      );

  @override
  Future<List<Todo>> get all => select(todos)
      .get()
      .then((rows) => rows.map(TodoModelExtension.fromTodoTable).toList());

  @override
  Future<Todo?> add(Todo todo) => into(todos)
      .insertReturningOrNull(
        TodosCompanion(
          title: Value(todo.title),
          description: Value(todo.description),
          isCompleted: Value(todo.isCompleted),
        ),
        mode: InsertMode.insertOrRollback,
      )
      .then(
        (row) => row != null ? TodoModelExtension.fromTodoTable(row) : null,
      );

  @override
  Future<Todo?> toggleTodoCompletion(Todo todo) async {
    if (todo.id == null) return null;

    final updateStatement =
        (update(todos)..where((row) => row.id.equals(todo.id!)));

    final updatedRow = (await updateStatement.writeReturning(
      TodoTableExtension.fromTodoModel(
        todo.copyWith(isCompleted: !todo.isCompleted),
      ),
    ))
        .singleOrNull;

    if (updatedRow != null) {
      return TodoModelExtension.fromTodoTable(updatedRow);
    }

    return null;
  }

  @override
  Future<Todo?> removeTodo(Todo todo) => delete(todos)
      .deleteReturning(
        TodosCompanion(
          id: Value(todo.id),
        ),
      )
      .then(
        (row) => row != null ? TodoModelExtension.fromTodoTable(row) : null,
      );
}
