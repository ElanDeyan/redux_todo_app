import 'package:flutter/material.dart';

class AddTodoFormTitle extends StatelessWidget {
  const AddTodoFormTitle() : super(key: const Key('add_todo_form_title'));

  @override
  Widget build(BuildContext context) {
    return Text(
      'Add a todo',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
