import 'package:flutter/material.dart';
import 'package:redux_todo_app/ui/add_todo_form/add_todo_form.dart';

/// {@template add_todo_form_title}
/// Widget to displays a title for the [AddTodoForm]
/// {@endtemplate}
class AddTodoFormTitle extends StatelessWidget {
  /// {@macro add_todo_form_title}
  const AddTodoFormTitle() : super(key: const Key('add_todo_form_title'));

  @override
  Widget build(BuildContext context) {
    return Text(
      'Add a to-do',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
