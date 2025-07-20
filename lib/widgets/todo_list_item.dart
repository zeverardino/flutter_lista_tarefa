import 'package:flutter/material.dart';

import 'package:flutter_lista_tarefa/models/todo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  TodoListItem({super.key, required this.todo, required this.onDelete});

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                  onPressed: (context) {
                      print('Deletar');
                      onDelete(todo);
                  },
                  icon: Icons.delete,
                  label: 'Excluir',
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,

              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[400],
            ),
            // margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          )
                      ),
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                ),
              ],
            ),
          ),
      ),
    );
  }
}


/*
ListTile(
            title: Text(todo),
            subtitle: Text('01/01/2025'),
            leading: Icon(Icons.person),
            onTap: () {
              print('Tarefa : $todo');
            },
            style:
        )
* */