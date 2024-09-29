import 'package:flutter/material.dart';
import 'package:redux_todo_app/models/models.dart';

/// {@template todo_tile_data_box}
/// [Widget] for display the [Todo.title] and [Todo.description] data.
/// {@endtemplate}
class TodoTileDataBox extends StatelessWidget {
  /// {@macro todo_tile_data_box}
  const TodoTileDataBox({
    required this.todo,
    super.key,
  });

  /// The [Todo] with the data.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodoTitle(todo: todo),
        if (todo.description != null) ...[
          const SizedBox(
            height: 5,
          ),
          _TodoTileDescription(todo: todo),
        ],
      ],
    );
  }
}

class _TodoTileDescription extends StatelessWidget {
  _TodoTileDescription({
    required this.todo,
  }) : super(key: ValueKey('${todo.id}_${todo.description}'));

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Text(
      todo.description!,
      style: TextStyle(
        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }
}

class _TodoTitle extends StatelessWidget {
  _TodoTitle({
    required this.todo,
  }) : super(key: ValueKey('${todo.id}_${todo.title}'));

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
          ),
    );
  }
}
