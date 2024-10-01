# Redux Todo app

A basic Todo app to practice and apply [Redux architecture](https://pub.dev/packages/redux).

## How to run this app

To run this app, you need to have Flutter installed in your host machine, either Windows, linux, MacOS, or even mobile devices (android and iOS) through an emulator or a real device.

> [!WARNING]
> This app was developed in a Windows machine and debugging with an adnroid device, and was not tested in linux, MacOS and iOS environments.

To test if you have flutter installed correctly, open a terminal and type:

```sh
flutter doctor
```

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

The `Store` is like a store which holds the `State` of your app. Think the "state of your app" like a piece of information(s) that your app needs to display the data accordingly. It's composed by a `Reducer`, a list of `Middleware`s and its initial `State`. We'll see more about them later.

So, looking from the point of view of the user, when you access the app, the interface (having one or more `View`s) will present information based on the data present in the `State`.

The app will have things, like a button, that, when pressed, will trigger an `Action`. `Action`s can be understood like intentions or events. They represent something that you want to do (and is related to your `State`), like "Hey, increment this counter" or "Add this todo task".

Alright, so, the `View`, thorough a button for instance, will trigger an `Action`, like add a todo task, but... to where was this `Action` triggered?

To the `Reducer`. It knows the actual app's `State`, receives an `Action` and returns an updated version of the `State` accordingly with the received `Action`. For instance, if we have an empty todo list (our `State` is an empty List of Todo items), and I trigger an "Add todo" `Action`, the `Reducer`  will returns a new version of the `State`, which contains the added todo, in our example.

Since Redux works with immutability, you should not modify the `State` object. Return a new version of it.

So, every `Action` is triggered to the `Reducer`, and then it updates the `Store`, right?

Wait! In fact, your dispatched `Action` will be sent to the `Reducer`. You're right! But, we have the `Middleware` component...

`Middleware`'s role is to intercept any triggered `Action` and do something with it. Looking to the flowchart above, you can see it lives between the triggered `Action` and the `Reducer`. It can, for instance:

- Log the actual `State` before the `Action` reach the `Reducer`, log the triggered `Action`, dispatch the `Action`, and then log the `State` after the `Action`! That's useful for debugging purposes.
- Write your `Action` data in a database or request an API.
- Change your `Action`, like add a todo in a database and, after successful, trigger an "updated" version of this `Action` with the todo with, for instance, an Id.
- Not dispatch this `Action`. Yes, the `Middleware` can simply not dispatch the `Action`. It'll never reach the `Reducer`.

`Middleware` is powerful! He has access to the `Store`, intercepts `Action`s before they reach the `Reducer` and can dispacth (or not) `Action`s, that can be modified or not!

Remember that the app needs the ``State`` to display the UI accordingly? What if I add the todo, like I said before, but nothing changes the UI? So, that's why the ``View`` depends of the ``State``.

When something change in the ``State``, we can imagine that something like this happended:

Store: "Hey View, my ``State`` has been changed, here's the new value. Please, update yourself."

View: "Okay, thanks for the advice. Updating!"

Therefore, our app will follow this cycle, depending on the `State`, provided by the `Store`, our app will display whatever it wants, like a todo list. You, the user, may want to do something, so, from the UI, you'll trigger an `Action`. Yor ``Action`` will be sent to the ``Reducer``, but, the ``Middleware`` is paying attention and will intercepts your ``Action`` before it reaches the ``Reducer``. The ``Middleware`` can do whatever it wants with the ``Action``: dispatches, modify then dispatch, not dispatch and so on... If it is dispatched, the ``Action`` will finally reach the `Reducer`, that will updates the `Store` with a **new** and updated `State`. Since your app is listening changes in the `State`, when it happens, the `View` will be updated accordingly.

## How this app uses Redux

Here we'll see an overview about how this app is using the redux architecture with Flutter.

Inside the `lib` directory, we have the following structure:

```txt
/actions
/db
/exceptions
/helper
/middlewares
/models
/providers
/reducers
/repository
/ui
app_state.dart
main.dart
service_locator.dart
```

We'll focus on the folders and files related to Redux.

### The Todo model

Here's the todo model for this app. (I omitted some things, you can check the full class in the `todo.dart`)

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

First, we have our app state defined inside the `app_state.dart` like the following:

```dart
final class AppState {
  const AppState({this.todos = const <Todo>[]});

  /// A list containing all [Todo]'s of the app.
  final List<Todo> todos;

  @override
  String toString() {
    return 'AppState(todos: $todos)';
  }
}
```

Our `State` will be a dart class containing a list of todos (the todo is defined in the `/models` folder).

### `Action`s

In this app, we'll have 3 actions, `AddTodoAction`, `ToggleTodoCompletionAction` and `RemoveTodoAction`. They were defined with a sealed class `TodoActions`, like the example below:

```dart
// imports...

/// Superclass for app actions
sealed class TodoActions {
  const TodoActions();
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
> It's useful to define your actions with Classes instead of enums when they need some data. If your action itself doesn't require any data, feel free to use enums.

### `Reducer`

The `Reducer` has a contract, it's a function that returns a `State`, and takes the actual `State` and the received `Action`.

```dart
// imports...

/// Reducer for the [AppState], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to generates a new State.
AppState todoReducer(AppState actualState, TodoActions action) =>
    switch (action) {
      AddTodoAction(:final todo) => _addTaskHandler(actualState, todo),
      ToggleTodoCompletionAction(:final todo) =>
        _toggleTaskCompletionHandler(actualState, todo),
      RemoveTodoAction(:final todo) => _removeTaskHandler(actualState, todo),
    };

// private functions...
```

The `Reducer` will take the new `State` and updates the `Store` (we'll see it soon).

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
/// Middleware to write operations in [TodosRepository] and
/// dispatches a new action with the data coming from the [TodosRepository]
/// if operation is successful.
Future<void> databaseWriter(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  final database = serviceLocator<TodosRepository>();

  switch (action) {
    case AddTodoAction(:final todo):
      await _onAddTask(database, todo, nextDispatcher);
    case ToggleTodoCompletionAction(:final todo):
      await _onToggleTaskCompletion(database, todo, nextDispatcher);
    case RemoveTodoAction(:final todo):
      await _onRemoveTask(database, todo, nextDispatcher);
  }
}

// sample callback
Future<void> _onAddTask(
  TodosRepository database,
  Todo todo,
  NextDispatcher nextDispatcher,
) async {
  final result = await database.add(todo);
  if (result != null) {
    nextDispatcher(
      AddTodoAction(
        todo: result,
      ),
    );
  }
}
```

As you can see, the `Middleware` can access the `Store`, the triggered `Action` and has a `NextDispatcher` callback, that, well, dispatches an `Action` to the next `Middleware`, if it exists, and so on until reaches the `Reducer`.

In the `databaseWriter` example, we extract the todo from the `Action` and performs an operation in the database. For instance, if we try to add a todo, but the db returns `null`, the `Action` will not be dispatched, but if is successful, then we'll dispatch the same kind of `Action`, but with a different todo, in that case, it will receive an int id, that was `null` before.

### `Store`

So, now we have all the ingredients to write the `Store`. I'm instantiating in the `app_store_provider`, inside a `StoreProvider` to our flutter app.

Here's an example of a `Store` instantiation.

```dart
final store = Store<AppState>(
      TypedReducer(todoReducer).call,
      initialState: const AppState(todos: dataThatCanComeFromTheDb),
      middleware: [
        TypedMiddleware(databaseWriter).call,
        TypedMiddleware(stateTransitionLogger).call,
      ],
    );
```

Here's the `AppStoreProvider` that, well, provides the `Store` to its descendants.

```dart
// app_store_provider.dart

/// [StoreProvider] for the app.
final class AppStoreProvider extends StatefulWidget {
  const AppStoreProvider({
    required this.child,
    super.key,
  });

  /// The child [Widget] for the [StoreProvider].
  final Widget child;

  @override
  State<AppStoreProvider> createState() => _AppStoreProviderState();
}

class _AppStoreProviderState extends State<AppStoreProvider> {
  late final Future<List<Todo>> _initialItems;
  @override
  void initState() {
    super.initState();
    _initialItems = serviceLocator<TodosRepository>().all;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _initialItems,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;
        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null =>
            StoreProvider(
              store: Store<AppState>(
                TypedReducer(todoReducer).call,
                initialState: AppState(todos: data),
                middleware: [
                  TypedMiddleware(databaseWriter).call,
                  TypedMiddleware(stateTransitionLogger).call,
                ],
              ),
              child: widget.child,
            ),
          _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
        };
      },
    );
  }
}
```

### View

The app has 3 places that triggers actions:

- A `FloatingActionButton` that, after the form is valid and the add button is tapped, triggers `AddTodoAction`.
- A `CheckBoxListTile` that when tapped triggers `ToggleTodoCompletionAction`.
- And an `IconButton` that, after the user confirms that want to remove a todo, triggers `RemoveTodoAction`.

## Final considerations

That's an overview of this app, built with flutter and using the redux architecture. It was an interesting experience and certainly can aggregate to my and you knowledge.
