import 'package:flutter/material.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile.dart';

/// {@template todo_tile_description}
/// A [Text] with style for a [Todo.description] in the [TodoTile].
/// {@endtemplate}
class TodoTileDescription extends StatelessWidget {
  /// {@macro todo_tile_description}
  TodoTileDescription({
    required this.todo,
  }) : super(key: ValueKey('${todo.id}_${todo.description}'));

  /// [Todo] for this Widget.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Text(
      todo.description ?? '',
      style: TextStyle(
        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        color: Theme.of(context).colorScheme.surfaceDim,
      ),
    );
  }
}
