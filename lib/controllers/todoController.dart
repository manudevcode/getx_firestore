import 'package:get/state_manager.dart';
import 'package:getx_firestore/models/todo.dart';
import 'package:getx_firestore/services/database.dart';

class TodoController extends GetxController {
  Rx<List<Todo>> todoList = Rx<List<Todo>>();

  List<Todo> get todos => todoList.value;

  @override
  void onInit() {
    todoList.bindStream(Database().todoStream());
  }
}