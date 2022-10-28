import 'package:todoapp/add_footer.dart';
import 'package:todoapp/add_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/providers.dart';
import 'package:todoapp/model.dart';
import 'package:todoapp/add_todo.dart';


class EditView extends ConsumerWidget{
  const EditView({Key? key}) : super(key: key);

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
            header: AddHeader(),
            footer: AddFooter(),
            onReorder: ( oldIndex,  newIndex){
              ref.read(todosProvider.notifier).drag(oldIndex, newIndex);
            },
            children: todolist.map((todo) =>
                InkWell(
                    key: Key(todo.key),
                    onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          String description = '';
                          return Consumer(
                              builder: (context, ref, _){
                                return AlertDialog(
                                  title: Text('タスクの編集'),
                                  content: SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value){
                                            description = value;
                                          },
                                          decoration:  InputDecoration(labelText: '${todo.description}', border: OutlineInputBorder()),
                                        ),
                                        SizedBox(height: 30,)
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.pop(context, 'OK');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                    ),
                    child: Card(
                        child: ListTile(
                            title:todo.isCompleted?Text('${todo.description}'):Text('${todo.description}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                            trailing: InkWell(
                              onTap: (){},
                              child: Icon(Icons.close, color: Colors.red,),
                            )
                        )
                    )
                )
            ).toList()
        ),
      ),
    );











  }






}