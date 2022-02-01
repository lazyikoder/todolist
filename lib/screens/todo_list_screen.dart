import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolistapp/firebase_api/database_method.dart';
import 'package:todolistapp/firebase_api/user_authentication.dart';
import 'package:todolistapp/models/todo_item.dart';
import 'package:todolistapp/screens/user_login_page.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final TextEditingController _newTask = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DataBaseMethod _dataBaseMethod;
  late UserAuth _userAuth;
  bool isdataloaded = false;
  late List<ToDoItemModel> toDoListModel;

  @override
  void initState() {
    super.initState();
    _dataBaseMethod = DataBaseMethod();
    _userAuth = UserAuth();
    getList();
  }

  void getList() async {
    List<ToDoItemModel> todolist = await _dataBaseMethod.getToDoList();
    setState(
      () {
        toDoListModel = todolist;
        isdataloaded = true;
      },
    );
  }

  addTask(String task) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> messageMap = {
        "message": _newTask.text,
        "isdone": false,
        // "todoId": ,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      await _dataBaseMethod.addTodoList(addToList: messageMap);
      getList();
    }
    _newTask.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _userAuth.userLogOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: isdataloaded
          ? showTaskList()
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogBox();
        },
        child: const Icon(
          Icons.add,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future showDeleteDialogBox(String taskId) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Do you want to delete this task"),
        actions: [
          CupertinoButton(
            child: const Text("Yes"),
            onPressed: () {
              _dataBaseMethod.deleteTodoList(taskId);
              Fluttertoast.showToast(msg: "Successfully deleted");

              getList();
              setState(() {});
              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future showDialogBox() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Task"),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (task) {
              return task!.isEmpty ? "Field cannot be empty" : null;
            },
            controller: _newTask,
            decoration: const InputDecoration(
              label: Text("Task"),
              hintText: "Add new task",
              border: UnderlineInputBorder(),
            ),
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Text("Ok"),
            onPressed: () {
              addTask(_newTask.text);
              Fluttertoast.showToast(msg: "Task successfully added");

              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            child: const Text("Cancel"),
            onPressed: () {
              _newTask.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget showTaskList() {
    return toDoListModel.isNotEmpty
        ? ListView.builder(
            itemCount: toDoListModel.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onLongPress: () {
                    showDeleteDialogBox(toDoListModel[index].toDoDocId);
                  },
                  child: Card(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        toDoListModel[index].message,
                        style: TextStyle(
                          decoration: toDoListModel[index].isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: toDoListModel[index].isDone
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      autofocus: false,
                      activeColor: Colors.teal,
                      checkColor: Colors.white,
                      selected: toDoListModel[index].isDone,
                      value: toDoListModel[index].isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          toDoListModel[index].isDone = value!;
                          _dataBaseMethod.updateTodoList(
                              toDoListModel[index].toDoDocId,
                              toDoListModel[index].isDone);
                        });
                      },
                    ),
                  ),
                ),
              );
            })
        : const Center(
            child: Text("Keep you today task here."),
          );
  }
}
