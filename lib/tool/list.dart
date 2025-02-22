// 扩展集合
extension ListExtension<T> on List<T> {
  // 交换元素位置后重排序
  List<T> swapReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return this;
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final T item = removeAt(oldIndex);
    insert(newIndex, item);
    return this;
  }

  // 对集合进行分组
  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    var map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
