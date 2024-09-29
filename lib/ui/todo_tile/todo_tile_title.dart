import 'package:flutter/material.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile.dart';

/// {@template todo_tile_title}
/// A [Text] with style for a [Todo.title] in the [TodoTile].
/// {@endtemplate}
class TodoTileTitle extends StatelessWidget {
  /// {@macro todo_tile_title}
  TodoTileTitle({
    required this.todo,
  }) : super(key: ValueKey('${todo.id}_${todo.title}'));

  /// The [Todo] for this Widget.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Text(
      todo.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
    );
  }
}
