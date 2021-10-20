import 'package:flutter/cupertino.dart';
import './database_helper.dart';

class TxProvider with ChangeNotifier {
  Future<List<Transaction>> get alltransaction async {
    List<Map<String, dynamic>> _allrows = await DatabaseHelper.instance.query();
    int _size = _allrows.length;
    List<Transaction> list = List.generate(_size, (index) {
      return Transaction(
        id: _allrows[index][DatabaseHelper.id],
        name: _allrows[index][DatabaseHelper.name],
        price: _allrows[index][DatabaseHelper.price],
        date: DateTime.parse(_allrows[index][DatabaseHelper.date]),
      );
    });
    list.sort(
        (a, b) => b.date.toIso8601String().compareTo(a.date.toIso8601String()));
    return list;
  }

  // Future<List<Transaction>> get last7DayTransaction async {
  //   List<Transaction> all = await alltransaction;
  //   List<Transaction> list;
  //   DateTime req = DateTime.now().subtract(const Duration(days: 7));
  //   for (Transaction val in all) {
  //     if (req.isBefore(val.date)) {
  //       list.add(val);
  //     } else {
  //       break;
  //     }
  //   }
  //   return list;
  // }

  Future<void> addTransaction(
      String title, double price, DateTime chosenDate) async {
    await DatabaseHelper.instance.insert({
      DatabaseHelper.name: title,
      DatabaseHelper.price: price,
      DatabaseHelper.date: chosenDate.toIso8601String(),
    });
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.delete(id);
    notifyListeners();
  }
}

class Transaction {
  int id;
  String name;
  num price;
  DateTime date;

  Transaction({
    this.name,
    this.price,
    this.date,
    this.id,
  });
}
