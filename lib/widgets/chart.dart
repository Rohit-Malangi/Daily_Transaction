import './char_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TxProvider.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Transaction> recentTransactionList;

  List<Map<String, Object>> get groupTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      var size =
          recentTransactionList == null ? 0 : recentTransactionList.length;
      for (int i = size - 1; i >= 0; --i)
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
    return FutureBuilder(
      future: Provider.of<TxProvider>(context).alltransaction,
      builder: (context, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.done ||
            dataSnapShot.connectionState == ConnectionState.waiting) {
          recentTransactionList = dataSnapShot.data as List<Transaction>;
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
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return Center(
            child: const Text('Loading...'),
          );
        }
      },
    );
  }
}
