import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/chart.dart';

class MyHomeScreen extends StatelessWidget {
  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Daily Transactions',
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
        shadowColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height) *
                0.3,
            child: Chart(),
          ),
          TransactionList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.yellow.shade400,
        child: Icon(Icons.add),
        onPressed: () => _startNewTransaction(context),
      ),
    );
  }
}
