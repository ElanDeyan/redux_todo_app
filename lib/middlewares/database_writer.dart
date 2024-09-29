import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/todo_actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';
import 'package:redux_todo_app/service_locator.dart';

/// Middleware to write operations in [TodosRepository] and
/// dispatches a new action with the data coming from the [TodosRepository].
Future<void> databaseWriter(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  final database = serviceLocator<TodosRepository>();

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
  TodosRepository database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.removeTodo(todo);
  if (result != null) {
    nextDispatcher(
      RemoveTask(
        todo: result,
      ),
    );
  }
}

Future<void> _onToggleTaskCompletion(
  TodosRepository database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.toggleTodoCompletion(todo);
  if (result != null) {
    nextDispatcher(
      ToggleTaskCompletion(
        todo: result,
      ),
    );
  }
}

Future<void> _onAddTask(
  TodosRepository database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.add(todo);
  if (result != null) {
    nextDispatcher(
      AddTask(
        todo: result,
      ),
    );
  }
}
