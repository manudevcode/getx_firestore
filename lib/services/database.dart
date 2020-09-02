import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getx_firestore/models/todo.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addTodo(String todo) async {
    try {
      await _firestore
        .collection('todos')
        .add({
          'createdAt': Timestamp.now(),
          'finished': false,
          'todo': todo
        });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> finishTodo(Todo todo) async{
    try {
      await _firestore
        .collection('todos')
        .doc(todo.todoId)
        .update({
          'finished': !todo.finished
        });
    } catch(e) { 
      print(e);
      rethrow;
    }
  }

  Future<void> deleteTodo(DocumentSnapshot todo) async{
    try {
      await _firestore
        .collection('todos')
        .doc(todo.id)
        .delete();
    } catch(e) { 
      print(e);
      rethrow;
    }
  }

    Stream<List<Todo>> todoStream() {
    return _firestore
        .collection("todos")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Todo> retVal = List();
      query.docs.forEach((element) {
        retVal.add(Todo.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}