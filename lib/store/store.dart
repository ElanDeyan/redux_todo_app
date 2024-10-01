import 'package:redux/redux.dart';
import 'package:redux_todo_app/middlewares/database_writer.dart';
import 'package:redux_todo_app/middlewares/state_transition_logger.dart';
import 'package:redux_todo_app/reducers/todo_reducer.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// App's [Store].
final store = Store<AppState>(
  TypedReducer(todoReducer).call,
  initialState: const AppState(),
  middleware: [
    TypedMiddleware(databaseWriter).call,
    TypedMiddleware(stateTransitionLogger).call,
  ],
);
