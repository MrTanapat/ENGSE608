class Event {
  final int? id;
  final String title;
  final String? description;
  final int categoryId;
  final String eventDate;
  final String startTime;
  final String endTime;
  final String status; // pending, in_progress, completed, cancelled
  final int priority;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.categoryId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    this.priority = 2,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'category_id': categoryId,
    'event_date': eventDate,
    'start_time': startTime,
    'end_time': endTime,
    'status': status,
    'priority': priority,
  };

  factory Event.fromMap(Map<String, dynamic> map) => Event(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    categoryId: map['category_id'],
    eventDate: map['event_date'],
    startTime: map['start_time'],
    endTime: map['end_time'],
    status: map['status'],
    priority: map['priority'],
  );
}
