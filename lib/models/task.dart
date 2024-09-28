class Task {
  Task({this.id,required this.title, this.isDone = false,this.category = 'Personal'});
  int? id;
  String title;
  bool isDone;
  String? category;
  Task copyWith({
    int? id,
    String? title,
    bool? isDone,
    String? category,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        category: category ?? this.category,
      );
  @override
  ///Check this for tasks.contains
  bool operator ==(Object other) {
    return other is Task && id == other.id &&other.title == title && category == other.category && other.isDone == isDone && hashCode == other.hashCode;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode;

  Map<String, dynamic> toJson() => {
        'id'  : id,
        'title': title,
        'category' :category,
        'isDone': isDone ? 1 : 0,
      };
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'],title: json['title'] ?? '', category : json['category'],isDone: json['isDone'] == 1,);

}
