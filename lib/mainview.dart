
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

    List display_box = [];
    List<DocumentSnapshot> fire_documents = [];

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
                stream: todoRef.orderBy('key').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData) {
                    final data = snapshot.data!;
                     fire_documents = snapshot.data!.docs;

                  display_box.clear();
                  for ( int i = 0; i < fire_documents.length; i++) {
                    display_box.add(fire_documents[i]['description']);
                  }

                  return Expanded(
                    child: ReorderableListView.builder(
                        itemCount: fire_documents.length,
                        itemBuilder: (context, index){
                          return ReorderCard(todo: data.docs[index].data(), key: Key(data.docs[index].data().key),);
                        },
                        onReorder: (int oldIndex, int newIndex) async{
                          if (oldIndex < newIndex) {
                            final String drug_row = display_box.removeAt(oldIndex);
                            display_box.insert(newIndex - 1, drug_row);

                            await todoRef
                                .where('seq', isGreaterThan: oldIndex * 2)
                                .where('seq', isLessThan: newIndex * 2)
                                .orderBy('seq')
                                .get()
                                .then((value) async {
                              for ( int i = 0; i < value.docs.length; i++) {
                                if (i == 0) {
                                  await todoRef
                                      .doc(value.docs[i].id)
                                      .update({'seq': newIndex * 2});
                                }else {
                                  await todoRef
                                      .doc(value.docs[i].id)
                                      .update({'seq':(2 * (i + oldIndex) - 1)});
                                }
                              }
                              await todoRef
                                  .doc(value.docs[0].id)
                                  .update({'seq': (newIndex * 2) - 1});
                            });
                          }

                          if (oldIndex > newIndex) {
                            final String drug_row = display_box.removeAt(oldIndex);
                            display_box.insert(newIndex - 1, drug_row);

                            await todoRef
                                .where('seq', isGreaterThan: newIndex * 2)
                                .where('seq', isLessThan: oldIndex * 2 + 2)
                                .orderBy('seq', descending: true)
                                .get()
                                .then((value) async{
                              for(int i = 0; i < value.docs.length; i++) {
                                if(i == 0){
                                  await todoRef
                                      .doc(value.docs[i].id)
                                      .update({'seq': newIndex * 2});
                                } else {
                                  await todoRef
                                      .doc(value.docs[i].id)
                                      .update({'seq':(3+ 2 * (oldIndex - i))});
                                }
                              }
                              await todoRef
                                  .doc(value.docs[0].id)
                                  .update({'seq': (newIndex * 2) + 1});
                            });
                          }
                        }
                    ),
                  );
                  } else return Text('');
                }
            )
          ],
        )
    );
  }
}


class ReorderCard extends StatefulWidget {
  const ReorderCard({Key? key, required this.todo}) : super(key: key);

  final ToDo todo;
  @override
  State<ReorderCard> createState() => _ReorderCardState();
}


class _ReorderCardState extends State<ReorderCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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

