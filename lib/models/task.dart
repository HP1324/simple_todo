class Task {
  Task({this.id,required this.title, this.isDone = false});
  int? id;
  String title;
  bool isDone;

  Task copyWith({
    int? id,
    String? title,
    bool? isDone,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );
  @override
  ///Check this for tasks.contains
  bool operator ==(Object other) {
    return other is Task && id == other.id &&other.title == title && other.isDone == isDone && hashCode == other.hashCode;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode;

  Map<String, dynamic> toJson() => {
        'id'  : id,
        'title': title,
        'isDone': isDone ? 1 : 0,
      };
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'],title: json['title'] ?? '', isDone: json['isDone'] == 1);

}
