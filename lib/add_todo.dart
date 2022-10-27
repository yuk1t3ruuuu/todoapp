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
    await todoRef.add(
        ToDo(id: todolist.length + 1,     //ここをリストの長さからdocの長さに変更したい　
            description: description!,
            isCompleted: true,
            key: (todolist.length + 1).toString()  //ここをリストの長さからdocの長さに変更したい
        )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}







