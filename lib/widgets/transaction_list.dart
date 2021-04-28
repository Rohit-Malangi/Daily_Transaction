import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../module/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function _deleteTransaction;
  TransactionList(this.transactionList, this._deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return transactionList.isEmpty
        ? LayoutBuilder(builder: (ctx, constrains) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "No transaction added yet!",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: constrains.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/image/daily_transaction.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            //because ListView.builder add one by one element in the parents size
            itemBuilder: (_, index) {
              return /*Card(
              color: Colors.yellow,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                            width: 3, color: Colors.deepPurple.shade400),
                        horizontal: BorderSide(
                            width: 3, color: Colors.deepPurple.shade400),
                      ),
                    ),
                    child: Text(
                      "Rs. ${transactionList[index].price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transactionList[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMEd()
                              .format(transactionList[index].date),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );*/
                  Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text(
                          'Rs. ${transactionList[index].price.toStringAsFixed(0)}',
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    transactionList[index].name,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactionList[index].date),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? TextButton.icon(
                          onPressed: () =>
                              _deleteTransaction(transactionList[index].id),
                          icon: Icon(Icons.delete),
                          label: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteTransaction(transactionList[index].id),
                        ),
                ),
              );
            },
            itemCount: transactionList.length,
          );
  }
}
