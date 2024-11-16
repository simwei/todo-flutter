import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
          ),
          body: const TodoList(),
        ));
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [
    Todo(done: true, text: "display todos"),
    Todo(done: true, text: "add todo"),
    Todo(done: true, text: "toggle done"),
    Todo(done: false, text: "drag and drop"),
  ];

  void toggleDone(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          AddTodoCard(onAdd: (todo) {
            addTodo(todo);
          }),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                var reverseIndex = todos.length - 1 - index;
                return TodoCard(
                    todo: todos.elementAt(reverseIndex),
                    onToggleDone: () {
                      toggleDone(reverseIndex);
                    },
                    onDelete: () {
                      removeTodo(reverseIndex);
                    });
              },
            ),
          ),
        ]));
  }
}

class Todo {
  bool done;
  String text;

  Todo({
    required this.done,
    required this.text,
  });
}

class AddTodoCard extends StatefulWidget {
  const AddTodoCard({super.key, required this.onAdd});

  final void Function(Todo todo) onAdd;

  @override
  State<AddTodoCard> createState() => _AddTodoCardState();
}

class _AddTodoCardState extends State<AddTodoCard> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (textController.text.isNotEmpty) {
      widget.onAdd(Todo(text: textController.text, done: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onEditingComplete: onSubmit,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'add',
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggleDone,
    required this.onDelete,
  });

  final Todo todo;
  final void Function() onToggleDone;

  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = todo.done
        ? colorScheme.secondaryContainer
        : colorScheme.primaryContainer;
    Color textColor = todo.done
        ? colorScheme.onSecondaryContainer
        : colorScheme.onPrimaryContainer;

    TextDecoration textDecoration =
        todo.done ? TextDecoration.lineThrough : TextDecoration.none;

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todo.text,
              style: TextStyle(
                color: textColor,
                decoration: textDecoration,
                decorationColor: textColor,
              ),
            ),
            Row(
              children: [
                IconButton(
                  color: textColor,
                  icon: todo.done
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank),
                  tooltip: 'toggle done',
                  onPressed: onToggleDone,
                ),
                IconButton(
                  color: textColor,
                  icon: const Icon(Icons.delete),
                  tooltip: 'delete',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
