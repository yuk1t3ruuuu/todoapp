import 'package:cloud_firestore/cloud_firestore.dart';
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

    final CollectionReference<ToDo> todoRef = FirebaseFirestore.instance.collection('todos')
        .withConverter<ToDo>(
      fromFirestore: (snapshots, _) => ToDo.fromJson(snapshots.data()!),
      toFirestore: (todo, _) => todo.toJson(),
    );



    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoリスト'),
        backgroundColor: Colors.green,
        actions: [
          edit.state?IconButton(onPressed: ()=> edit.state = !edit.state, icon: Icon(Icons.edit))
              :IconButton(onPressed: ()=> edit.state = !edit.state, icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot<ToDo>>(
              stream: todoRef.snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final data = snapshot.data!;
                  return Expanded(
                    child: ReorderableListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, index){
                          return reorderCard(todo: data.docs[index].data());
                        },
                        onReorder: (int oldIndex, int newIndex){
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = data.docs.removeAt(oldIndex);
                          data.docs.insert(newIndex, item);
                        }
                    ),
                  );
                }
                else return Text('');
              }
          )
        ],
      )
    );
  }
}


class reorderCard extends StatefulWidget {
  const reorderCard({Key? key, required this.todo}) : super(key: key);

  final ToDo todo;
  @override
  State<reorderCard> createState() => _reorderCardState();
}

class _reorderCardState extends State<reorderCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        key: Key(widget.todo.key),
        onTap: () {},
        child: Card(
            child: ListTile(
              title:widget.todo.isCompleted?Text('${widget.todo.description}'):Text('${widget.todo.description}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
              trailing: widget.todo.isCompleted?Text(' '):Icon(Icons.check, color: Colors.green,),

            )
        )
    );
  }
}
