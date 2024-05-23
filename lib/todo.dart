class Todo {
  final String? id;
  final String uid;
  final String title;
  final String? description;
  bool isCompleted;
  final String created;

  Todo(
      {this.id,
      required this.uid,
      required this.title,
      this.description,
      required this.isCompleted,
      required this.created});
}
