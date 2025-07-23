import 'package:equatable/equatable.dart';

class TodoEnti extends Equatable {
  final int? id;
  final int iconId;
  final int isDone;
  final String title;
  final String description;
  final String time;

  const TodoEnti(
      {this.id,
      required this.iconId,
      required this.isDone,
      required this.title,
      required this.description,
      required this.time});
  @override
  List<Object?> get props => [id, iconId, isDone, title, description, time];
}
