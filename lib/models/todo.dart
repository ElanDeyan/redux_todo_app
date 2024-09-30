import 'package:equatable/equatable.dart';
import 'package:redux_todo_app/db/app_database.dart';

/// {@template todo_model}
/// [Todo] with three properties: [title], [description], and
/// [isCompleted].
/// {@endtemplate}
final class Todo extends Equatable {
  /// {@macro todo_model}
  const Todo({
    required this.title,
    required DateTime createdAtTime,
    this.id,
    this.description,
    this.isCompleted = false,
  }) : _createdAt = createdAtTime;

  /// Task's id. Can be [Null] when creating, since after added to [AppDatabase]
  /// he'll receive an id.
  final int? id;

  /// Title of [Todo]
  final String title;

  /// A description about this [Todo]
  final String? description;

  /// Marks a [Todo] as completed or not.
  final bool isCompleted;

  final DateTime _createdAt;

  /// [DateTime] of [Todo]'s creation.
  DateTime get createdAt => _createdAt;

  /// Negatable version of [isCompleted].
  /// Checks if a [Todo] is not completed.
  bool get isNotCompleted => !isCompleted;

  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt];

  /// Helper method to create a copy of actual [Todo] with specific changes.
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAtTime: createdAt ?? this.createdAt,
    );
  }
}
