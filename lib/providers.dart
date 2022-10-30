import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/model.dart';

List<ToDo> todolist = [
  ToDo( description: 'タスク1', isCompleted: true, key: '1',seq: 1 ),
  ToDo( description: 'タスク2', isCompleted: true, key: '2',seq: 1),
  ToDo(description: 'タスク3', isCompleted: true, key: '3',seq: 1),
  ToDo(description: 'タスク4', isCompleted: true, key: '4',seq: 1)
];

class TodoNotifier extends StateNotifier<List<ToDo>> {
  TodoNotifier() : super(todolist);

  void addTopTodo(ToDo todo) {
    state = [todo, ...state];
  }

  void addBottomTodo(ToDo todo) {
    state = [...state, todo ];
  }



  void drag (int oldIndex, int newIndex){
    List<ToDo> index = [...state];
    if (oldIndex < newIndex){
      newIndex -= 1;
    }
    ToDo num = index.removeAt(oldIndex);
    index.insert(newIndex, num);
    state = index;
  }



}

final todosProvider = StateNotifierProvider<TodoNotifier, List<ToDo>>((ref) {
  return TodoNotifier();
});

final editProvider = StateProvider((ref) => true);


