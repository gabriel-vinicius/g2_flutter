import 'package:cloud_firestore/cloud_firestore.dart';

enum EisenhowerQuadrant {
  urgentImportant,        // Fazer agora
  notUrgentImportant,     // Agendar
  urgentNotImportant,     // Delegar
  notUrgentNotImportant,  // Eliminar
}

EisenhowerQuadrant quadrantFromString(String? v) {
  switch (v) {
    case 'urgentImportant':
      return EisenhowerQuadrant.urgentImportant;
    case 'notUrgentImportant':
      return EisenhowerQuadrant.notUrgentImportant;
    case 'urgentNotImportant':
      return EisenhowerQuadrant.urgentNotImportant;
    case 'notUrgentNotImportant':
      return EisenhowerQuadrant.notUrgentNotImportant;
    default:
      return EisenhowerQuadrant.notUrgentImportant;
  }
}

String quadrantToString(EisenhowerQuadrant q) {
  switch (q) {
    case EisenhowerQuadrant.urgentImportant:
      return 'urgentImportant';
    case EisenhowerQuadrant.notUrgentImportant:
      return 'notUrgentImportant';
    case EisenhowerQuadrant.urgentNotImportant:
      return 'urgentNotImportant';
    case EisenhowerQuadrant.notUrgentNotImportant:
      return 'notUrgentNotImportant';
  }
}

class TaskModel {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;
  final DateTime? dueAt;
  final EisenhowerQuadrant quadrant;

  TaskModel({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
    required this.quadrant,
    this.dueAt,
  });

  factory TaskModel.newLocal({
    required String title,
    required EisenhowerQuadrant quadrant,
    DateTime? dueAt,
  }) =>
      TaskModel(
        id: '',
        title: title,
        done: false,
        createdAt: DateTime.now(),
        quadrant: quadrant,
        dueAt: dueAt,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'done': done,
        'createdAt': Timestamp.fromDate(createdAt),
        'dueAt': dueAt != null ? Timestamp.fromDate(dueAt!) : null,
        'quadrant': quadrantToString(quadrant),
      }..removeWhere((k, v) => v == null);

  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return TaskModel(
      id: doc.id,
      title: (d['title'] as String?) ?? '',
      done: (d['done'] as bool?) ?? false,
      createdAt: ((d['createdAt'] as Timestamp?) ?? Timestamp.now()).toDate(),
      dueAt: (d['dueAt'] is Timestamp) ? (d['dueAt'] as Timestamp).toDate() : null,
      quadrant: quadrantFromString(d['quadrant'] as String?),
    );
  }
}
