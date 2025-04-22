import 'dart:collection';

class CartState {
  static final CartState _instance = CartState._internal();

  factory CartState() => _instance;

  CartState._internal();

  final List<Map<String, dynamic>> _cartData = [];

  void clearCart() {
    _cartData.clear();
  }

  int getQuantity(String subcategoryId, String taskId) {
    final subcategory = _cartData.firstWhere(
          (sub) => sub['subcategoryId'] == subcategoryId,
      orElse: () => {},
    );

    if (subcategory.isNotEmpty) {
      final task = (subcategory['tasks'] as List<Map<String, dynamic>>)
          .firstWhere(
            (task) => task['taskId'] == taskId,
        orElse: () => {},
      );
      if (task.isNotEmpty) {
        return task['qty'] ?? 0;
      }
    }
    return 0;
  }

  List<Map<String, dynamic>> _getOrCreateTaskList(String subcategoryId) {
    final subcategory = _cartData.firstWhere(
          (sub) => sub['subcategoryId'] == subcategoryId,
      orElse: () {
        final newSubcategory = {
          'subcategoryId': subcategoryId,
          'tasks': <Map<String, dynamic>>[],
        };
        _cartData.add(newSubcategory);
        return newSubcategory;
      },
    );
    return subcategory['tasks'];
  }

  void increment(
      String subcategoryId,
      String taskId, {
        required String name,
        required double price,
      }) {
    final taskList = _getOrCreateTaskList(subcategoryId);

    final existingTask = taskList.firstWhere(
          (task) => task['taskId'] == taskId,
      orElse: () => {},
    );

    if (existingTask.isNotEmpty) {
      existingTask['qty'] = (existingTask['qty'] ?? 0) + 1;
    } else {
      taskList.add({
        'taskId': taskId,
        'qty': 1,
        'name': name,
        'price': price,
      });
    }
  }

  void decrement(String subcategoryId, String taskId) {
    final taskList = _getOrCreateTaskList(subcategoryId);

    for (var i = 0; i < taskList.length; i++) {
      if (taskList[i]['taskId'] == taskId) {
        taskList[i]['qty'] -= 1;
        if (taskList[i]['qty'] <= 0) {
          taskList.removeAt(i);
        }
        break;
      }
    }
  }

  List<Map<String, dynamic>> getJson() => UnmodifiableListView(_cartData);

  List<Map<String, dynamic>> getFlatTaskList() {
    final List<Map<String, dynamic>> flatList = [];

    for (final subcategory in _cartData) {
      for (final task in subcategory['tasks']) {
        if (task['qty'] > 0) {
          flatList.add({
            'subcategoryID': subcategory['subcategoryId'],
            'taskID': task['taskId'],
            'name': task['name'],
            'price': task['price'],
            'qty': task['qty'],
          });
        }
      }
    }

    return flatList;
  }
}