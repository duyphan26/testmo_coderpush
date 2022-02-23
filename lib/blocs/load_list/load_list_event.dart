import 'package:testmo_coderpush/repository/models/entity.dart';

abstract class LoadListEvent {
  final Map<String, dynamic>? params;

  const LoadListEvent([this.params]);
}

class LoadListStarted extends LoadListEvent {
  LoadListStarted({
    Map<String, dynamic>? params,
  }) : super(params);
}

class LoadListNextPage<T extends Entity> extends LoadListEvent {
  final List<T>? nextItems;

  const LoadListNextPage({
    Map<String, dynamic>? params,
    required this.nextItems,
  }) : super(params);
}

class LoadListRefreshed extends LoadListEvent {
  LoadListRefreshed({
    Map<String, dynamic>? params,
  }) : super(params);
}
