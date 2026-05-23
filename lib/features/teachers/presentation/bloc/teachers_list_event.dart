import 'package:equatable/equatable.dart';

abstract class TeachersListEvent extends Equatable {
  const TeachersListEvent();
  @override
  List<Object?> get props => [];
}

class TeachersListLoadRequested extends TeachersListEvent {
  const TeachersListLoadRequested();
}

class TeachersListSearchChanged extends TeachersListEvent {
  final String query;
  const TeachersListSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class TeachersListSubjectFiltered extends TeachersListEvent {
  final String? subject;
  const TeachersListSubjectFiltered(this.subject);
  @override
  List<Object?> get props => [subject];
}

class TeachersListLoadMoreRequested extends TeachersListEvent {
  const TeachersListLoadMoreRequested();
}
