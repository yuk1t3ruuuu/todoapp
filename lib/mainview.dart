import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/providers.dart';
import 'package:todoapp/model.dart';


class BaseView extends ConsumerWidget{
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final List<ToDo> todolist = ref.watch(todosProvider);
    final edit = ref.watch(editProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoリスト'),
        backgroundColor: Colors.green,
        actions: [
          edit.state?IconButton(onPressed: ()=> edit.state = !edit.state, icon: Icon(Icons.edit))
              :IconButton(onPressed: ()=> edit.state = !edit.state, icon: Icon(Icons.check))
        ],
      ),
      body: Container(
        child: ReorderableListView(
            onReorder: ( oldIndex,  newIndex){
              ref.read(todosProvider.notifier).drag(oldIndex, newIndex);
            },
            children: todolist.map((todo) =>
                InkWell(
                    key: Key(todo.key),
                    onTap: () => ref.read(todosProvider.notifier).toggle(todo.id),
                    child: Card(
                        child: ListTile(
                          title:todo.isCompleted?Text('${todo.description}'):Text('${todo.description}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                          trailing: todo.isCompleted?Text(' '):Icon(Icons.check, color: Colors.green,),

                        )
                    )
                )
            ).toList()
        ),
      ),
    );











  }






}