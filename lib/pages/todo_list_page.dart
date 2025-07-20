import 'package:flutter/material.dart';
import 'package:flutter_lista_tarefa/models/todo.dart';
import 'package:flutter_lista_tarefa/repositories/todo_repository.dart';
import 'package:flutter_lista_tarefa/widgets/todo_list_item.dart';



class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  void initState(){
    super.initState();
    todoRepository.loadTodo().then((value) {
      setState(() {
        todos = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
      
                          ),
                          labelText: 'Adicionar Tarefa',
                          hintText: 'Ex. Estudar',
                          errorText: errorText,
                        ),
                        controller: todoController,
                        onChanged: (value) {
                          if(value.isNotEmpty){
                            setState(() {
                              errorText = null;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 9),
                    ElevatedButton(
                        onPressed: () {
                          String text = todoController.text;
                          print(text);
                          if(text.isEmpty){
                            setState(() {
                              errorText = 'Campo obrigatório';
                            });
                            //validaCampoVazio();
                            return;
                          }
                          setState(() {
                            Todo newTodo = Todo(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            todos.add(newTodo);
                            errorText = null;
                          });
                          todoController.clear();
                          todoRepository.saveTodo(todos);
                        },
                        child: Icon(
                            Icons.add,
                            size: 30,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          foregroundColor: Colors.blueGrey,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                        for(Todo todo in todos)
                          TodoListItem(
                            todo: todo,
                            onDelete: onDelete,
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
      
                    Expanded(
                      child:
                        Text(
                            'Você possui ${todos.length} tarefas',
                            style: TextStyle(
                                fontSize: 17
                            ),
                        )
                    ),
                    ElevatedButton(
                      onPressed: showDeleteAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        foregroundColor: Colors.blueGrey,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
      
                      ),
                      child:
                        Text(
                            'Limpar tudo',
                            style: TextStyle(
                                fontSize: 17
                            ),
                        ),
      
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // function callback
  void onDelete(Todo todo){
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(
                    'Tarefa ${todo.title} foi removido!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                ),
            backgroundColor: Colors.red[400],
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: Colors.green,
              onPressed: () {
                setState(() {
                  todos.insert(deletedTodoPos!, deletedTodo!);
                });
                todoRepository.saveTodo(todos);
              },
            ),
            duration: Duration(seconds: 5),
        )
    );

  }

  void showDeleteAll(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Limpar tudo?'),
          content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
          actions: [

            TextButton(
                onPressed: deleteAllCancel,
                child: Text('Cancelar'),

            ),
            TextButton(
                onPressed: deleteAllOk,
                child: Text(
                    'Limpar Tudo',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),
                )
            ),
          ],
        )
    );
  }

  void deleteAllOk(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodo(todos);
    Navigator.of(context).pop();

  }

  void deleteAllCancel(){
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Operação cancelada!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.orange,
        )
    );
  }

  void validaCampoVazio(){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('OK'),
            content: Text('Campo de tarefa obrigatório'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          )
      );
  }

}