import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/middlewares/middlewares.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/reducers/reducers.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';
import 'package:redux_todo_app/store/app_state.dart';

final class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  late AppState state;
  late Store<AppState> store;
  late MockTodosRepository todosRepository;

  setUp(() {
    state = const AppState();
    store = Store(
      TypedReducer(todoReducer).call,
      initialState: state,
      middleware: [
        TypedMiddleware(databaseWriter).call,
      ],
    );
    todosRepository = MockTodosRepository();

    if (!GetIt.instance
        .isRegistered<TodosRepository>(instance: todosRepository)) {
      GetIt.instance.registerSingleton<TodosRepository>(todosRepository);
    }
  });

  test('Starts empty', () {
    expect(store.state, equals(state));
  });

  group('Add todo action', () {
    final sample = Todo(
      title: faker.lorem.sentence(),
      description: faker.lorem.sentences(5).join(' '),
      createdAtTime: DateTime.now(),
    );

    setUp(() {
      when(() => todosRepository.add(sample))
          .thenAnswer((_) async => sample.copyWith(id: 1));
    });

    test('Adding todo', () async {
      await store.dispatch(AddTodoAction(todo: sample));

      expect(store.state.todos, contains(sample.copyWith(id: 1)));
    });

    test('Adding todo', () async {
      await store.dispatch(AddTodoAction(todo: sample));

      expect(store.state.todos, contains(sample.copyWith(id: 1)));
    });

    test('Adding todo', () async {
      await store.dispatch(AddTodoAction(todo: sample));

      expect(store.state.todos, contains(sample.copyWith(id: 1)));
    });
  });
}
