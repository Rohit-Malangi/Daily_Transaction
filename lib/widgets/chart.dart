import './char_bar.dart';
import 'package:flutter/material.dart';
import '../module/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactionList;
  final double sizeOfString;
  Chart(this.recentTransactionList, this.sizeOfString);
  List<Map<String, Object>> get groupTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = recentTransactionList.length - 1; i >= 0; --i)
        if (recentTransactionList[i].date.day == weekDay.day &&
            recentTransactionList[i].date.month == weekDay.month &&
            recentTransactionList[i].date.year == weekDay.year)
          totalSum += recentTransactionList[i].price;
      return {
        'days': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get sumofAllDays {
    return groupTransaction.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransaction.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['days'],
                data['amount'],
                sumofAllDays == 0.0
                    ? 0.0
                    : (data['amount'] as double) / sumofAllDays,
                sizeOfString,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
