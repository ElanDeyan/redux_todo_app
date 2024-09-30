import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/add_todo_form/add_todo_form.dart';

/// {@template add_todo_floating_action_button}
/// A [FloatingActionButton] wrapped with a [StoreConnector] to dispatch a
/// [AddTodoAction] action, when the user not dismisses the bottom
/// sheet or the [Form]
/// is valid.
/// {@endtemplate}
class AddTodoFloatingActionButton extends StatelessWidget {
  /// {@macro add_todo_floating_action_button}
  const AddTodoFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(Todo todo)>(
      converter: (store) => (todo) => store.dispatch(AddTodoAction(todo: todo)),
      builder: (context, addTodoCallback) => FloatingActionButton.extended(
        onPressed: () => _onPressed(context, addTodoCallback),
        label: const Text('Add todo'),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }

  Future<void> _onPressed(
    BuildContext context,
    void Function(Todo todo) addTodoCallback,
  ) async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AddTodoFormTitle(),
        content: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: const AddTodoForm(),
        ),
      ),
    );

    if (result != null) {
      addTodoCallback(result);
    }
  }
}
