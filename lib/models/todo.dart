/// {@template todo_model}
/// [Todo] with three properties: [title], [description], and
/// [isCompleted].
/// {@endtemplate}
final class Todo {
  /// {@macro todo_model}
  Todo({
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  /// Title of [Todo]
  final String title;

  /// A description about this [Todo]
  final String description;

  /// Marks a [Todo] as completed or not.
  final bool isCompleted;

  /// Negatable version of [isCompleted].
  /// Checks if a [Todo] is not completed.
  bool get isNotCompleted => !isCompleted;
}
