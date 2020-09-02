import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:getx_firestore/controllers/todoController.dart';
import 'package:getx_firestore/services/database.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData.dark(),
    );
  }
}

class Home extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if (snapshot.hasError) {
              return Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return TodoList();
            }

            return Text('Cargando');
          },
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {

  final TextEditingController _todoCtrl = TextEditingController();
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  child: TextField(
                    controller: _todoCtrl,
                    decoration: InputDecoration.collapsed(hintText: 'Agregar todo'),
                    onSubmitted: (value) {
                      if (_todoCtrl.text != ""){
                        Database()
                          .addTodo(_todoCtrl.text);

                        _todoCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_todoCtrl.text != ""){
                    Database()
                      .addTodo(_todoCtrl.text);

                    _todoCtrl.clear();
                  }
                },
              )
            ],
          ),
        ),

        GetX<TodoController>(
          init: Get.put<TodoController>(TodoController()),
          builder: (TodoController todoController) {
            if (todoController != null && todoController.todos != null) {
              return Expanded(
                child: ListView.builder(
                  itemCount: todoController.todos.length,
                  itemBuilder: (_, index) {
                    return ListTile(                      
                      title: Text(todoController.todos[index].todo),
                      trailing: IconButton(
                        icon: Icon(Icons.done, color: todoController.todos[index].finished ? Colors.green : Colors.white),
                        onPressed: () {
                          Database().finishTodo(todoController.todos[index]);
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('Cargando las tareas');
            }
          },
        ),
      ],
    );
  }
}