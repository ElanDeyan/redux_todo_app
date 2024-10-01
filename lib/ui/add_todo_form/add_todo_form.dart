import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';

/// {@template add_todo_form}
/// [Form] to add a [Todo] in [TodosRepository]
/// {@endtemplate}
class AddTodoForm extends StatefulWidget {
  /// {@macro add_todo_form}
  const AddTodoForm({
    super.key,
  });

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _key = GlobalKey<FormState>(debugLabel: 'add_todo_form_key');
  late final TextEditingController _titleEditingController;
  late final TextEditingController _descriptionEditingController;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateTitleField,
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: TextFormField(
                controller: _descriptionEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () => _onAddTodoPressed(context),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateTitleField(String? value) {
    if (isBlank(value)) {
      return 'Cannot be empty or blank';
    }

    return null;
  }

  void _onAddTodoPressed(BuildContext context) {
    if (_key.currentState?.validate() ?? false) {
      // widget.onAddTodo();
      Navigator.pop(
        context,
        Todo(
          title: _titleEditingController.text.trim(),
          description: isNotBlank(_descriptionEditingController.text)
              ? _descriptionEditingController.text.trim()
              : null,
          createdAtTime: DateTime.now(),
        ),
      );
    }
  }
}
