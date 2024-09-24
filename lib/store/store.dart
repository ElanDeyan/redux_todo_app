import 'package:redux_todo_app/models/todo.dart';

/// {@template app_store}
/// App's store in redux architecture.
/// {@endtemplate}
final class AppStore {
  /// {@macro app_store}
  const AppStore({required this.todos});

  /// A list containing all [Todo]'s of the app.
  final List<Todo> todos;
}
