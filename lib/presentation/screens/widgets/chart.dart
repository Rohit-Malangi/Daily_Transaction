import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/transaction.dart';
import '../../../logic/bloc/transaction_bloc.dart';

import './char_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key key}) : super(key: key);

  List<Map<String, Object>> groupTransaction(
      List<Transaction> recentTransactionList) {
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

  double sumofAllDays(List<Transaction> recentTransactionList) {
    return groupTransaction(recentTransactionList).fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
      if (state is TransactionInitial) {
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (state is TransactionAllState) {
        List<Transaction> recentTransactionList = state.list;
        return Card(
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupTransaction(recentTransactionList).map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['days'],
                    data['amount'],
                    sumofAllDays(recentTransactionList) == 0.0
                        ? 0.0
                        : (data['amount'] as double) /
                            sumofAllDays(recentTransactionList),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }
      if (state is TransactionErrorState) {
        final error = state.error;
        return Center(
          child: Container(
            child: Text(
              "$error...",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return null;
    });
  }
}
