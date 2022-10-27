import 'package:flutter/material.dart';

@immutable
class ToDo{
   const ToDo({
    required this.id,
    required this.description,
    required this.isCompleted,
    required this.key
  });

  ToDo.fromJson(Map<String, Object?> json)
    :this(
    id: json['id']! as int,
    description: json['description']! as String,
    isCompleted: json['isCompleted']! as bool,
    key: json['key']! as String,
  );

  final int id;
  final String description;
  final bool isCompleted;
  final String key;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
      'key': key,
    };
  }

  ToDo copyWith({int? id, String? description, bool? isCompleted, String? key }) {
    return ToDo(
        id: id?? this.id,
        description: description?? this.description,
        isCompleted: isCompleted?? this.isCompleted,
        key: key?? this.key
    );
  }
}