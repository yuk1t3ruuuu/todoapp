import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/providers.dart';
import 'package:todoapp/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/add_todo.dart';

class AddFooter extends ConsumerWidget{
  const AddFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    TextEditingController descriptionEditingController = TextEditingController();

    return InkWell(
      onTap: ()=> showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return Consumer(
              builder: (context, ref, _){
                return AlertDialog(
                  title:  Text('タスクの追加'),
                  content: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: descriptionEditingController,
                          decoration:  InputDecoration(labelText: 'タスク名', border: OutlineInputBorder()),
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
                        AddToDo();
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
      ),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.add),
          title: Text('タスクを追加'),
        ),
      ),
    );
  }
}