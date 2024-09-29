import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile_description.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile_title.dart';

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
    return StoreBuilder<AppState>(
      builder: (context, store) => InkWell(
        onLongPress: () => _displayTodoData(context),
        child: CheckboxListTile(
          value: todo.isCompleted,
          onChanged: (_) =>
              store.dispatch(ToggleTodoCompletionAction(todo: todo)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          tileColor: Theme.of(context).colorScheme.primaryContainer,
          secondary: IconButton(
            onPressed: () => _onDeleteTodo(
              context,
              () => store.dispatch(RemoveTodoAction(todo: todo)),
            ),
            icon: const Icon(Icons.delete),
          ),
          title: TodoTileTitle(todo: todo),
          subtitle: TodoTileDescription(todo: todo),
        ),
      ),
    );
  }

  Future<void> _displayTodoData(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: todo.asDataTable,
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
