import 'package:redux/redux.dart';
import 'package:redux_todo_app/middlewares/middlewares.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/reducers/reducers.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// Returns a [Store] with a provided [initialItems].
Store<AppState> getStore(List<Todo> initialItems) => Store<AppState>(
      TypedReducer(todoReducer).call,
      initialState: AppState(todos: initialItems),
      middleware: [
        TypedMiddleware(databaseWriter).call,
        TypedMiddleware(stateTransitionLogger).call,
      ],
    );
