class Task{
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  int? color;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.color,
});

  Task.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['color'] = this.color;
    return data;
  }
}