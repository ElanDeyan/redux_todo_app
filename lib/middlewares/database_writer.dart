import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/todo_actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/helper/extensions/todo_model.dart';
import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/service_locator.dart';

/// Middleware to write operations in [AppDatabase] and dispatch a new action
/// with the data coming from the [AppDatabase].
Future<void> databaseWriter(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  final database = serviceLocator<AppDatabase>();

  switch (action) {
    case AddTask(:final todo):
      await _onAddTask(database, todo, nextDispatcher);
    case ToggleTaskCompletion(:final todo):
      await _onToggleTaskCompletion(database, todo, nextDispatcher);
    case RemoveTask(:final todo):
      await _onRemoveTask(database, todo, nextDispatcher);
  }
}

Future<void> _onRemoveTask(
  AppDatabase database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.remove(todo);
  if (result != null) {
    nextDispatcher(
      RemoveTask(
        todo: TodoModel.fromTodoTable(result),
      ),
    );
  }
}

Future<void> _onToggleTaskCompletion(
  AppDatabase database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.toggleTaskCompletion(todo);
  if (result != null) {
    nextDispatcher(
      ToggleTaskCompletion(
        todo: TodoModel.fromTodoTable(result),
      ),
    );
  }
}

Future<void> _onAddTask(
  AppDatabase database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.add(todo);
  if (result != null) {
    nextDispatcher(
      AddTask(
        todo: TodoModel.fromTodoTable(result),
      ),
    );
  }
}
