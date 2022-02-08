import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolistapp/globals/global_variables.dart';
import 'package:todolistapp/models/todo_item.dart';

class DataBaseMethod {
  Future<bool> storeUserDataOnSignUp(
    Map<String, dynamic> userInfo,
    String userDocId,
  ) async {
    bool isDataStore = false;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userDocId)
          .set(userInfo)
          .then(
            (value) => isDataStore = true,
          );
    } catch (e) {
      // ignore: avoid_print
      print(
        e.toString(),
      );
    }
    return isDataStore;
  }

  Future addTodoList({Map<String, dynamic>? addToList}) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(globalUSERDOCID)
          .collection("todolist")
          .add(addToList!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<List<ToDoItemModel>> getToDoList() async {
    List<ToDoItemModel> todolistmodel = [];
    try {
      Map<String, dynamic> mapResult;
      QuerySnapshot _response = (await FirebaseFirestore.instance
          .collection("users")
          .doc(globalUSERDOCID)
          .collection("todolist")
          .orderBy(
            "time",
            descending: true,
          )
          .get());

      for (var element in _response.docs) {
        ToDoItemModel object = ToDoItemModel.fromMap(element);
        todolistmodel.add(object);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return todolistmodel;
  }

  Future updateTodoList(String todoDocId, bool isDone) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(globalUSERDOCID)
        .collection("todolist")
        .doc(todoDocId)
        .update(
      {
        'isdone': isDone,
      },
    );
  }

  Future deleteTodoList(String todoDocId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(globalUSERDOCID)
        .collection("todolist")
        .doc(todoDocId)
        .delete();
  }
}
