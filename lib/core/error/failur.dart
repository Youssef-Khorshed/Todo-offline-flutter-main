// failur.dart
import 'package:equatable/equatable.dart';

abstract class Failur extends Equatable {
  final String? message; // Add a message field

  const Failur([this.message]); // Constructor accepts an optional message

  @override
  List<Object?> get props =>
      [message]; // Include message in props for Equatable
}

class EmpityFailur extends Failur {
  // Optionally provide a default message or pass one in
  const EmpityFailur([String? message]) : super(message ?? "No data found");

  @override
  List<Object?> get props => [...super.props]; // Include parent props
}

class SqlFailur extends Failur {
  // Optionally provide a default message or pass one in
  const SqlFailur([String? message])
      : super(message ?? "Database error occurred");

  @override
  List<Object?> get props => [...super.props]; // Include parent props
}

// When creating a failure in your data layer, you can now pass a message:
// return Left(SqlFailur("Failed to insert todo: ${e.toString()}"));
