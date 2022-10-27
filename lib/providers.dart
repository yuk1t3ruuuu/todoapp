import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/model.dart';

List<ToDo> todolist = [
  ToDo(id: 0, description: 'タスク1', isCompleted: true, key: '1'),
  ToDo(id: 1, description: 'タスク2', isCompleted: true, key: '2'),
  ToDo(id: 2, description: 'タスク3', isCompleted: true, key: '3'),
  ToDo(id: 3, description: 'タスク4', isCompleted: true, key: '4')
];

class TodoNotifier extends StateNotifier<List<ToDo>> {
  TodoNotifier() : super(todolist);

  void addTopTodo(ToDo todo) {
    state = [todo, ...state];
  }

  void addBottomTodo(ToDo todo) {
    state = [...state, todo ];
  }


  void removeTodo(int id) {
    state = [
      for(final todo in state)
        if(todo.id != id) todo
    ];
  }

  void toggle(int id) {
    state = [
      for(final todo in state)
        if(todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo
    ];
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

  void editDescription(int id, String description){
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(description: description)
        else
          todo
    ];
  }


}

final todosProvider = StateNotifierProvider<TodoNotifier, List<ToDo>>((ref) {
  return TodoNotifier();
});

final editProvider = StateProvider((ref) => true);


