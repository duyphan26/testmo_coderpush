import 'package:equatable/equatable.dart';
import 'package:testmo_coderpush/repository/models/entity.dart';

abstract class LoadListState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadListRunInitial extends LoadListState {}

class LoadListStartRunInProgress extends LoadListState {}

class LoadListLoadPageRunSuccess<T extends Entity> extends LoadListState {
  final List<T> items;
  final List<T> currItems;
  final int nextPage;

  LoadListLoadPageRunSuccess(
    this.items, {
    required this.currItems,
    this.nextPage = 0,
  });

  @override
  List<Object> get props => [
        items,
        nextPage,
      ];
}

class LoadListLoadPageRunFailure extends LoadListState {
  final String errorMessage;
  final dynamic error;

  LoadListLoadPageRunFailure(this.errorMessage, this.error);

  @override
  List<Object> get props => [errorMessage];
}
