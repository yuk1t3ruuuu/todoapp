import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/model.dart';
import 'package:todoapp/providers.dart';

class AddToDo extends StatelessWidget {
   AddToDo({Key? key,}) : super(key: key);


  final CollectionReference<ToDo> todoRef = FirebaseFirestore.instance.collection('todos')
      .withConverter<ToDo>(
    fromFirestore: (snapshots, _) => ToDo.fromJson(snapshots.data()!),
    toFirestore: (todo, _) => todo.toJson(),
  );


  addToDo({String? description})async{
    final todoSnapshot = await todoRef.get();
    final todos = todoSnapshot.docs.length;
    await todoRef.add(
        ToDo(
            description: description!,
            isCompleted: true,
            key: (todos + 1).toString(),
            seq: todos + 1
        )
    );

  }

  deleteToDo({String? id}) async {
    await todoRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}







