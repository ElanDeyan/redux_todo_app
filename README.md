# Redux To-do app

A basic To-do app to practice and apply [Redux architecture](https://pub.dev/packages/redux).

## How to run this app

To run this app, you need to have Flutter installed in your host machine, either Windows, linux, MacOS, or even mobile devices (android and iOS) through an emulator or a real device.

> [!WARNING]
> This app was developed in a Windows machine and debugging with an android device, and was not tested in linux, MacOS and iOS environments.

To test if you have flutter installed correctly, open a terminal and type:

```sh
flutter doctor
```

If you don't have flutter, follow [these instructions](https://docs.flutter.dev/get-started/install) to install both Flutter and the necessary dependencies to run the project.

If it's okay, [clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository), open the project's folder in your terminal, then type:

```sh
flutter run --profile
```

The `--profile` will run a profile version of the app, which is closer of the release (public) version, so it has better performance.

Probably you'll be prompted to choose from a set of options (Windows, Chrome, an Android Emulator...). Type the option number acordingly and wait.

## Redux architecture

The redux architecture is based in the following components (considering a UI application with a view):

- app's `State`
- one `Store`
- one (or more, combined in one) `Reducer`
- `Action`s
- `Middleware`s
- `View`s

The following image explains better the relationship between these components:

![Flow chart of redux architecture with a view](https://blog.logrocket.com/wp-content/uploads/2021/10/redux-with-middleware.png)

The `Store` is like a... store... which holds the `State` of your app. Think the "state of your app" like a piece of information(s) that your app needs to display the data accordingly. It's composed by a `Reducer`, a list of `Middleware`s and its initial `State`. We'll see more about them later.

So, looking from the point of view of the user, when you access the app, the interface (having one or more `View`s) will present information based on the data present in the `State`.

The app will have things, like a button, that, when pressed, will trigger an `Action`. `Action`s can be understood like intentions or events. They represent something that you want to do (and are related to your `State`), like "Hey, increment this counter" or "Add this to-do task".

Alright, so, the `View`, through a button, for instance, will trigger an `Action`, like add a to-do task, but... where was this `Action` triggered?

To the `Reducer`. It knows the actual app's `State`, receives an `Action` and returns a new and updated version of the `State` accordingly with the received `Action`. For instance, if we have an empty to-do list (our `State` is an empty List of to-do items), and I trigger an "Add to-do" `Action`, the `Reducer`  will returns a new version of the `State`, which contains the added to-do, in our example.

Since Redux works with immutability, you should not modify the `State` object. Return a new version of it instead.

So, every `Action` is triggered to the `Reducer`, and then it updates the `Store`, right?

Wait! In fact, your dispatched `Action` will be sent to the `Reducer`. You're right! But, we have the `Middleware` component...

`Middleware`'s role is to intercept any triggered `Action` and do something with it. Looking to the flowchart above, you can see it lives between the triggered `Action` and the `Reducer`. It can, for instance:

- Log the actual `State` before the `Action` reaches the `Reducer`, log the triggered `Action`, dispatch the `Action`, and then log the `State` after that `Action`! That's useful for debugging purposes.
- Write your `Action` data in a database or request an API.
- Change your `Action`, like receive a `FetchTodosAction` and then dispatched an `AddManyTodosAction`.
- Not dispatch this `Action`. Yes, the `Middleware` can simply not dispatch the `Action`. It'll never reaches the `Reducer`.

`Middleware` is powerful! He has access to the `Store`, intercepts `Action`s before they reach the `Reducer` and can dispacth (or not) `Action`s, that can be modified or not!

Remember that the app needs the `State` to display the UI accordingly? What if I add the to-do, like I said before, but nothing changes the UI? That's why the `View` should depends, and is "listening", the `State`.

When something change in the `State`, we can imagine that something like this happened:

Store: "Hey View, my `State` has been changed, here's the new value. Please, update yourself."

View: "Okay, thanks for the advice. Updating!"

Therefore, our app will follow this cycle, depending on the `State`, provided by the `Store`, our app will display whatever it wants, like a to-do list. We, as users, may want to do something, so, from the UI, we'll trigger an `Action`. That `Action` will be sent to the `Reducer`, but, the `Middleware` is paying attention and will intercepts your `Action` before it reaches the `Reducer`. The `Middleware` can do whatever it wants with the `Action`: dispatches, modify then dispatch, not dispatch and so on... If it is dispatched, the dispatched `Action` will finally reach the `Reducer`, that will updates the `Store` with a **new** and updated `State`. Since your app is "listening" changes in the `State`, when it happens, the `View` will be updated accordingly.

## How this app uses Redux

Here we'll see an overview about how this app is using the redux architecture with Flutter.

Inside the `lib` directory, we have the following structure (I'll omit some folders not directly related to redux):

```txt
/actions
  --- todo_actions.dart
/middlewares
  --- database_writer.dart
  --- state_transition_logger.dart
/providers
  --- app_store_provider.dart // it's related to provide the store to our flutter widgets
/reducers
  --- todo_reducer.dart
/store
  --- app_state.dart
  --- store.dart
main.dart
```

We'll focus on the folders and files related to Redux.

### The to-do model

Here's the to-do model for this app. (I omitted some things, you can check the full class in the `lib/models/todo.dart`)

```dart
/// [Todo] with three properties: [title], [description], and
/// [isCompleted].
final class Todo extends Equatable {
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
}

```

### App's `State`

First, we have our app state defined inside the `lib/store/app_state.dart` like the following:

```dart
/// App's store in redux architecture.
final class AppState extends Equatable {
  const AppState({this.todos = const <Todo>[]});

  /// A list containing all [Todo]'s of the app.
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];

  @override
  String toString() {
    return 'AppState(todos: $todos)';
  }
}
```

Our `State` will be a dart class containing a list of to-dos (the to-do is defined in the `lib/models` folder).

### `Action`s

In this app, we'll have 5 actions, `AddTodoAction`, `ToggleTodoCompletionAction`, `RemoveTodoAction`, `FetchAllTodosAction` and `AddManyTodosActions`. They were defined with a sealed class `TodoActions`, like the example below:

```dart
// imports...

/// Superclass for app actions
sealed class TodoActions {
  const TodoActions();
}

/// Action that represents fetching all [Todo]s in the [TodosRepository].
final class FetchAllTodosAction extends TodoActions {
  const FetchAllTodosAction();

  @override
  String toString() {
    return "Fetch all to-do's in database";
  }
}

/// Action to add a [List] of [Todo]s in [TodosRepository].
final class AddManyTodosAction extends TodoActions {
  const AddManyTodosAction(this.todos);

  /// [Todo]s to be added.
  final List<Todo> todos;

  @override
  String toString() {
    return 'Adding many todos: $todos';
  }
}

/// Action for add a [Todo] to the [AppState]
final class AddTodoAction extends TodoActions {
  const AddTodoAction({required this.todo});

  /// A [Todo] to be added
  final Todo todo;

  @override
  String toString() {
    return 'Add task: $todo';
  }
}

/// Action for toggle [Todo.isCompleted] property.
final class ToggleTodoCompletionAction extends TodoActions {
  const ToggleTodoCompletionAction({required this.todo});

  /// A [Todo] where its [Todo.isCompleted] will be negate.
  final Todo todo;

  @override
  String toString() {
    return 'Toggle the isCompleted property of $todo';
  }
}

/// Action for remove [Todo] from the [AppState]
final class RemoveTodoAction extends TodoActions {
  const RemoveTodoAction({required this.todo});

  /// A [Todo] to be removed.
  final Todo todo;

  @override
  String toString() {
    return 'Remove this todo: $todo';
  }
}
```

> [!TIP]
> Define your actions with classes instead of enums when they need some data. If your action itself doesn't require any data, feel free to use enums.

### `Reducer`

The `Reducer` has a contract, it's a function that returns a `State`, and takes the actual `State` and the received `Action`.

```dart
// imports...

/// Reducer for the [AppState], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to returns a new [AppState].
AppState todoReducer(AppState actualState, TodoActions action) =>
    switch (action) {
      final FetchAllTodosAction _ => actualState,
      AddTodoAction(:final todo) => _addTaskHandler(actualState, todo),
      AddManyTodosAction(:final todos) =>
        _addManyTodosHandler(actualState, todos),
      ToggleTodoCompletionAction(:final todo) =>
        _toggleTaskCompletionHandler(actualState, todo),
      RemoveTodoAction(:final todo) => _removeTaskHandler(actualState, todo),
    };

AppState _addTaskHandler(AppState actualState, Todo todo) =>
    AppState(todos: [...actualState.todos, todo]);

// private functions...
```

The `Reducer` will returns a new `State` and updates the `Store`.

### `Middleware`s

This app has 2 `Middleware`s:

- A `stateTransitionLogger`, that logs the `State` before and after a specific `Action`.
- `databaseWriter` that does the appropriate operation on the database accordingly the `Action`.

```dart
/// Logger function to logs the previous [AppState] state,
/// the fired [TodoActions], and the resulted [AppState] state.
void stateTransitionLogger(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) {
  log('Previous state: ${store.state}');
  log('Fired action: $action', name: 'StateTransitionLogger');
  nextDispatcher(action);
  log('Actual state: ${store.state}');
}
```

```dart
/// Middleware to read/write operations in [TodosRepository] and
/// dispatches a new action with the data coming from the [TodosRepository]
/// if operation is successful.
Future<void> databaseWriter(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  final repository = serviceLocator<TodosRepository>();

  switch (action) {
    case final FetchAllTodosAction _:
      await _onFetchAllTodosAction(repository, nextDispatcher);
    case AddManyTodosAction(:final todos):
      await _onAddManyTodos(repository, todos, nextDispatcher);
    case AddTodoAction(:final todo):
      await _onAddTodo(repository, todo, nextDispatcher);
    case ToggleTodoCompletionAction(:final todo):
      await _onToggleTodoCompletion(repository, todo, nextDispatcher);
    case RemoveTodoAction(:final todo):
      await _onRemoveTodo(repository, todo, nextDispatcher);
  }
}

Future<void> _onFetchAllTodosAction(
  TodosRepository repository,
  NextDispatcher nextDispatcher,
) async {
  final todos = await repository.all;

  nextDispatcher(AddManyTodosAction(todos));
}

Future<void> _onAddManyTodos(
  TodosRepository repository,
  List<Todo> todos,
  NextDispatcher nextDispatcher,
) async {
  final todosToDispatch = <Todo>[];

  for (final todo in todos) {
    final addedTodo = await repository.add(todo);
    if (addedTodo != null) todosToDispatch.add(addedTodo);
  }

  nextDispatcher(AddManyTodosAction(todosToDispatch));
}
```

As you can see, the `Middleware` can access the `Store`, the triggered `Action` and has a `NextDispatcher` callback, that, well, dispatches an `Action` to the next `Middleware`, if it exists, and so on, until reaches the `Reducer`.

In the `databaseWriter` example, we extract the data from the `Action` (if it has) using pattern matching and performs an operation in the database. For instance, if we try to add a to-do, but the db returns `null`, the `Action` will not be dispatched, but if is successful, then we'll dispatch the same kind of `Action`, but with a different to-do, in that case, it will receive an int id, that was `null` before.

### `Store`

So, now we have all the ingredients to write the `Store`.

Here's an example of a `Store` instantiation.

```dart
/// App's [Store].
final store = Store<AppState>(
  TypedReducer(todoReducer).call,
  initialState: const AppState(),
  middleware: [
    TypedMiddleware(databaseWriter).call,
    TypedMiddleware(stateTransitionLogger).call,
  ],
);
```

Here's the `AppStoreProvider` that, well, provides the `Store` to its descendants.

```dart
// app_store_provider.dart
// imports...
import 'package:redux_todo_app/store/store.dart';

/// {@template app_store_provider}
/// [StoreProvider] for the app.
/// {@endtemplate}
final class AppStoreProvider extends StatelessWidget {
  /// {@macro app_store_provider}
  const AppStoreProvider({
    required this.child,
    super.key,
  });

  /// The child [Widget] for the [StoreProvider].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: child,
    );
  }
}
```

### View

Here are an example of how this app triggers `Action`s from the UI:

- A `FloatingActionButton` that, after the form is valid and the add button is tapped, triggers `AddTodoAction`.

```dart
/// A [FloatingActionButton] wrapped with a [StoreConnector] to dispatch a
/// [AddTodoAction] action, when the user not dismisses the bottom
/// sheet or the [Form] is valid.
class AddTodoFloatingActionButton extends StatelessWidget {
  const AddTodoFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(Todo todo)>(
      converter: (store) => (todo) => store.dispatch(AddTodoAction(todo: todo)),
      builder: (context, addTodoCallback) => FloatingActionButton.extended(
        onPressed: () => _onPressed(context, addTodoCallback), // in the _onPressed mthos we may call the addTodoCallback and dispatch AddTodoAction with a provided Todo
        label: const Text('Add to-do'),
        icon: const Icon(Icons.add_task_outlined),
      ),
    );
  }

  // a private method...
}
```

- A `CheckBoxListTile` that when tapped triggers `ToggleTodoCompletionAction`.
- And an `IconButton` that, after the user confirms that want to remove a todo, triggers `RemoveTodoAction`.

An interesting use case is to fetch the `Todo`s from the database.

```dart
/// The main page of the application
final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.checklist_outlined),
        title: const Text('Redux to-do app'),
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.inverseSurface,
        child: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(const FetchAllTodosAction()),
          builder: (context, store) => const TodosListView(),
        ),
      ),
      floatingActionButton: const AddTodoFloatingActionButton(),
    );
  }
}
```

## Final considerations

That's an overview of this app, built with flutter and using the redux architecture. It was an interesting experience and certainly can aggregate to my and your knowledge.
