class ToDoItemModel {
  String message;
  bool isDone;
  String toDoDocId;
  ToDoItemModel({
    required this.message,
    required this.isDone,
    required this.toDoDocId,
  });
  factory ToDoItemModel.fromMap(QueryDocumentSnapshot map) {
    return ToDoItemModel(
      message: map["message"],
      isDone: map["isdone"],
      toDoDocId: map.id,
    );
  }
}
