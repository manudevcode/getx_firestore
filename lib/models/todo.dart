import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String todo;
  String todoId;
  Timestamp createdAt;
  bool finished;

  Todo(
    this.todo,
    this.todoId,
    this.createdAt,
    this.finished
  );

  Todo.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot
  ) {
    todoId = documentSnapshot.id;
    todo = documentSnapshot.data()['todo'];
    createdAt = documentSnapshot.data()['createdAt'];
    finished = documentSnapshot.data()['finished'];
  }
}