import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/todo_actions.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';
import 'package:redux_todo_app/service_locator.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// Middleware to write operations in [TodosRepository] and
/// dispatches a new action with the data coming from the [TodosRepository]
/// if operation is successful.
Future<void> databaseWriter(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  final repository = serviceLocator<TodosRepository>();

  switch (action) {
    case final FetchAllTodosAction _:
      await _onFetchAllTodosAction(repository, nextDispatcher);
    case AddManyTodosAction(:final todos):
      await _onAddManyTodos(repository, todos, nextDispatcher);
    case AddTodoAction(:final todo):
      await _onAddTodo(repository, todo, nextDispatcher);
    case ToggleTodoCompletionAction(:final todo):
      await _onToggleTodoCompletion(repository, todo, nextDispatcher);
    case RemoveTodoAction(:final todo):
      await _onRemoveTodo(repository, todo, nextDispatcher);
  }
}

Future<void> _onFetchAllTodosAction(
  TodosRepository repository,
  NextDispatcher nextDispatcher,
) async {
  final todos = await repository.all;

  nextDispatcher(AddManyTodosAction(todos));
}

Future<void> _onAddManyTodos(
  TodosRepository repository,
  List<Todo> todos,
  NextDispatcher nextDispatcher,
) async {
  final todosToDispatch = <Todo>[];

  for (final todo in todos) {
    final addedTodo = await repository.add(todo);
    if (addedTodo != null) todosToDispatch.add(addedTodo);
  }

  nextDispatcher(AddManyTodosAction(todosToDispatch));
}

Future<void> _onRemoveTodo(
  TodosRepository repository,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await repository.removeTodo(todo);
  if (result != null) {
    nextDispatcher(
      RemoveTodoAction(
        todo: result,
      ),
    );
  }
}

Future<void> _onToggleTodoCompletion(
  TodosRepository repository,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await repository.toggleTodoCompletion(todo);
  if (result != null) {
    nextDispatcher(
      ToggleTodoCompletionAction(
        todo: result,
      ),
    );
  }
}

Future<void> _onAddTodo(
  TodosRepository repository,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await repository.add(todo);
  if (result != null) {
    nextDispatcher(
      AddTodoAction(
        todo: result,
      ),
    );
  }
}
