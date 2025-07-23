import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failur.dart';
import 'package:todo/features/todo/domain/entities/todo_enti.dart';
import 'package:todo/features/todo/domain/usecases/delete_done_todo.dart';
import 'package:todo/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:todo/features/todo/domain/usecases/get_done_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_not_done_todo.dart';
import 'package:todo/features/todo/domain/usecases/insert_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetDoneTodoUsecase getDoneTodoUsecase;
  final GetNotDoneTodoUsecase getNotDoneTodoUsecase;
  final InsertTodoUsecase insertTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  TodoBloc(
      {required this.getDoneTodoUsecase,
      required this.deleteTodoUsecase,
      required this.getNotDoneTodoUsecase,
      required this.insertTodoUsecase,
      required this.updateTodoUsecase})
      : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {});
    //
    on<GetDoneTodoEvent>((event, emit) async {
      emit(LoadingTodoState());
      var failurOrDone = await getDoneTodoUsecase.call();
      emit(_getData(failurOrDone));
    });
    //
    on<GetNotDoneTodoEvent>((event, emit) async {
      emit(LoadingTodoState());
      var failurOrDone = await getNotDoneTodoUsecase.call();
      emit(_getData(failurOrDone));
    });
    //
    on<AddTodoEvent>((event, emit) async {
      emit(LoadingTodoState());
      var failurOrDone = await insertTodoUsecase.call(event.todoEnti);
      emit(_insertAndDelete(failurOrDone));
      add(GetNotDoneTodoEvent());
    });
    //
    on<UpdateTodoEvent>((event, emit) async {
      emit(LoadingTodoState());

      late Either<Failur, Unit> failurOrDone;
      for (var i = 0; i < event.idsTodo.length; i++) {
        failurOrDone = await updateTodoUsecase.call(event.idsTodo[i]);
      }
      emit(_insertAndDelete(failurOrDone));
      add(GetNotDoneTodoEvent());
    });
    // --- NEW: DeleteTodoEvent Handler ---
    on<DeleteTodoEvent>((event, emit) async {
      emit(LoadingTodoState());
      // Call the delete use case with the provided ID
      final failureOrDone = await deleteTodoUsecase.call(event.idTodo);
      // Process the result using the existing helper
      emit(_insertAndDelete(failureOrDone));
      // Refresh the lists. Decide which list(s) need refreshing based on your app's logic.
      // If deleting from "Not Done" list:
      add(GetNotDoneTodoEvent());
      // If deleting from "Done" list:
      // add(GetDoneTodoEvent());
      // Or refresh both if items can be deleted from either.
      // add(GetNotDoneTodoEvent());
      // add(GetDoneTodoEvent());
    });
    // --- END NEW ---
  }
}

////////////
TodoState _getData(Either<Failur, List<TodoEnti>> either) {
  return either.fold((failur) {
    return ErrorTodoState(message: failur.message ?? "An error occured");
  }, (listData) {
    return LoadedTodoState(todoList: listData);
  });
}

///////////
TodoState _insertAndDelete(Either<Failur, Unit> either) {
  return either.fold((failur) {
    return ErrorTodoState(message: failur.message ?? "An error occured");
  }, (done) {
    return const LoadedTodoState();
  });
}
