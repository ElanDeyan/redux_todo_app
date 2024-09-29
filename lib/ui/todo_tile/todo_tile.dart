import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile_data_box.dart';

/// {@template todo_tile}
/// [StatelessWidget] for the [Todo], which can toggle [Todo.isCompleted],
/// remove this [Todo].
/// {@endtemplate}
class TodoTile extends StatelessWidget {
  /// {@macro todo_tile}
  const TodoTile({required this.todo, super.key});

  /// The [Todo] of this widget.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StoreConnector<AppState, VoidCallback>(
              converter: (store) =>
                  () => store.dispatch(ToggleTaskCompletion(todo: todo)),
              builder: (context, callback) => Checkbox(
                value: todo.isCompleted,
                onChanged: (_) => callback(),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(child: TodoTileDataBox(todo: todo)),
            StoreConnector<AppState, VoidCallback>(
              builder: (context, callback) => IconButton(
                onPressed: () => _onDeleteTodo(context, callback),
                icon: const Icon(Icons.delete_forever_outlined),
              ),
              converter: (store) =>
                  () => store.dispatch(RemoveTask(todo: todo)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteTodo(
    BuildContext context,
    VoidCallback callback,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AlertDialog(
        icon: Icon(Icons.delete_forever_outlined),
        title: Text('Are you sure?'),
        content: Text('This action cannot be undone'),
        actions: [
          _CancelDeleteTodoDialogButton(),
          _DeleteTodoDialogButton(),
        ],
      ),
    );

    if (result ?? false) {
      callback();
    }
  }
}

class _CancelDeleteTodoDialogButton extends StatelessWidget {
  const _CancelDeleteTodoDialogButton()
      : super(key: const Key('cancel_delete_todo_dialog_button'));

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context, false),
      child: const Text('Cancel'),
    );
  }
}

class _DeleteTodoDialogButton extends StatelessWidget {
  const _DeleteTodoDialogButton()
      : super(key: const Key('delete_todo_dialog_button'));

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.errorContainer,
        ),
        foregroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      child: const Text('Delete'),
    );
  }
}
