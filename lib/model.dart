import 'package:flutter/material.dart';

@immutable
class ToDo{
   const ToDo({
    required this.description,
    required this.isCompleted,
    required this.key,
    required this.seq
  });

  ToDo.fromJson(Map<String, Object?> json)
    :this(
    description: json['description']! as String,
    isCompleted: json['isCompleted']! as bool,
    key: json['key']! as String,
    seq: json['seq']! as int
  );

  final String description;
  final bool isCompleted;
  final String key;
  final int seq;

  Map<String, Object?> toJson() {
    return {
      'description': description,
      'isCompleted': isCompleted,
      'key': key,
      'seq': seq
    };
  }

  ToDo copyWith({String? description, bool? isCompleted, String? key, int? seq }) {
    return ToDo(
        description: description?? this.description,
        isCompleted: isCompleted?? this.isCompleted,
        key: key?? this.key,
        seq: seq?? this.seq
    );
  }
}