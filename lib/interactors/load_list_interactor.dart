abstract class LoadListInteractor<T> {
  Future<List<T>?> loadItems({Map<String, dynamic>? params});
}
