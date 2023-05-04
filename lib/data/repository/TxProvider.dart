import '../model/transaction.dart';
import '../provider/database_helper.dart';

class TxProvider {
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

  Future<List<Transaction>> get last7DayTransaction async {
    List<Transaction> all = await alltransaction;
    List<Transaction> list;
    DateTime req = DateTime.now().subtract(const Duration(days: 7));
    for (Transaction val in all) {
      if (req.isBefore(val.date)) {
        list.add(val);
      } else {
        break;
      }
    }
    return list;
  }

  Future<int> addTransaction(
      String title, double price, DateTime chosenDate) async {
    try {
      int id = await DatabaseHelper.instance.insert({
        DatabaseHelper.name: title,
        DatabaseHelper.price: price,
        DatabaseHelper.date: chosenDate.toIso8601String(),
      });
      return id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
    } catch (e) {
      return false;
    }
    return true;
  }
}
