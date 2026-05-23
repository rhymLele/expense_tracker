import 'package:equatable/equatable.dart';

abstract class EnrollmentsEvent extends Equatable {
  const EnrollmentsEvent();
  @override
  List<Object?> get props => [];
}

class EnrollmentsLoadRequested extends EnrollmentsEvent {
  const EnrollmentsLoadRequested();
}

class EnrollmentsRefreshRequested extends EnrollmentsEvent {
  const EnrollmentsRefreshRequested();
}
