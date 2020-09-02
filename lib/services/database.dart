import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getx_firestore/models/todo.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(String todo) async {
    try{
      await _firestore
        .collection('todos')
        .add({
          'createdAt': Timestamp.now(),
          'finished': false,
          'todo': todo
        });
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<void> finishTodo(Todo todo) async {
    try {
      await _firestore
        .collection('todos')
        .doc(todo.todoId)
        .update({
          'finished': !todo.finished
        });
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await _firestore
        .collection('todos')
        .doc(todo.todoId)
        .delete();
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Stream<List<Todo>> todoStream() {
    return _firestore
      .collection('todos')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((QuerySnapshot query){
        List<Todo> retVal = List();
        query.docs.forEach((element) {
          retVal.add(Todo.fromDocumentSnapshot(element));
        });
        return retVal;
      });
  }
}