import 'package:equatable/equatable.dart';
import 'package:testmo_coderpush/repository/models/models.dart';

abstract class PeopleState extends Equatable {
  final User user;

  PeopleState(this.user);

  @override
  List<Object> get props => [
        user,
      ];
}

class PeopleRunInitial extends PeopleState {
  PeopleRunInitial(User user) : super(user);
}

class PeopleLoadDetailInfoRunSuccess extends PeopleState {
  PeopleLoadDetailInfoRunSuccess(User user) : super(user);
}

class PeopleLoadDetailInfoRunFailure extends PeopleState {
  PeopleLoadDetailInfoRunFailure(User user) : super(user);
}
