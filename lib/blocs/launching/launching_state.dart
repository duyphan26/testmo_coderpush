import 'package:equatable/equatable.dart';

abstract class LaunchingState extends Equatable {
  LaunchingState();

  @override
  List<Object> get props => [];
}

class LaunchingRunInitial extends LaunchingState {}

class LaunchingPreloadDataRunInProgress extends LaunchingState {}

class LaunchingPreloadDataRunSuccess extends LaunchingState {
  final String mockData;

  LaunchingPreloadDataRunSuccess({
    required this.mockData,
  });
}

class LaunchingPreloadDataRunFailure extends LaunchingState {}
