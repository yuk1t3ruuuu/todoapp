import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/providers.dart';
import 'package:todoapp/mainview.dart';
import 'package:todoapp/editview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp( const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ToDoPage(),
    );
  }
}



class ToDoPage extends ConsumerWidget{
  const ToDoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final edit = ref.watch(editProvider.state);

    return edit.state?BaseView():EditView();
  }
}
