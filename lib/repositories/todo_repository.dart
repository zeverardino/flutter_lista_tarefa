import 'dart:convert';

import 'package:flutter_lista_tarefa/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo_list';

class TodoRepository{

  late SharedPreferences sharedPreferences;

  void saveTodo(List<Todo> todos){
    final jsonString = jsonEncode(todos);
    print(jsonString);
    sharedPreferences.setString(todoListKey, jsonString);
  }

  Future<List<Todo>> loadTodo() async {
      sharedPreferences = await SharedPreferences.getInstance();
      final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
      final List jsonDecoded = jsonDecode(jsonString) as List;
      return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  
}
