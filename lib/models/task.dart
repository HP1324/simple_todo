class Task {
  Task({required this.title, this.isDone = false});

  String title;
  bool isDone;

  @override
  ///Check this for tasks.contains
  bool operator ==(Object other) {
    return other is Task && other.title == title && other.isDone == isDone;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode;

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone ? 1 : 0,
      };
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'], isDone: json['isDone'] == 1);

}
