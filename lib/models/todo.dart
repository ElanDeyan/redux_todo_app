import 'package:equatable/equatable.dart';

/// {@template todo_model}
/// [Todo] with three properties: [title], [description], and
/// [isCompleted].
/// {@endtemplate}
final class Todo extends Equatable {
  /// {@macro todo_model}
  const Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
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

  @override
  List<Object?> get props => [title, description, isCompleted];
}
