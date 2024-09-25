import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';

/// {@template todo_not_found_exception}
/// An [Exception] class for missing [Todo]s in [AppState]
/// {@endtemplate}
final class TodoNotFoundException implements Exception {
  /// {@macro todo_not_found_exception}
  const TodoNotFoundException(this.todo, [String? message])
      : message = message ?? 'Todo not found: $todo';

  /// [String] for a message of the exception
  final String message;

  /// The missing [Todo].
  final Todo todo;
}
