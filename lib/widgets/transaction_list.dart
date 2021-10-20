import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/TxProvider.dart';

class TransactionList extends StatefulWidget {
  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> _transactionList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TxProvider>(context).alltransaction,
      builder: (ctx, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.done ||
            dataSnapShot.connectionState == ConnectionState.waiting) {
          if (dataSnapShot.hasData) {
            _transactionList = dataSnapShot.data as List<Transaction>;
            return _transactionList.isEmpty
                ? Center(
                    child: Container(
                      child: const Text(
                        "No transaction added yet!",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(
                    /*height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            AppBar().preferredSize.height) *
                        0.667,*/
                    child: Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade300,
                                foregroundColor: Colors.black,
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: FittedBox(
                                    child: Text(
                                      'Rs. ${_transactionList[index].price.toStringAsFixed(0)}',
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                _transactionList[index].name,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              subtitle: Text(
                                DateFormat.yMMMd()
                                    .format(_transactionList[index].date),
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: MediaQuery.of(context).size.width > 400
                                  ? TextButton.icon(
                                      onPressed: () {
                                        Provider.of<TxProvider>(context,
                                                listen: false)
                                            .deleteTransaction(
                                                _transactionList[index].id);
                                      },
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
                                      onPressed: () {
                                        Provider.of<TxProvider>(context,
                                                listen: false)
                                            .deleteTransaction(
                                                _transactionList[index].id);
                                      }),
                            ),
                          );
                        },
                        itemCount: _transactionList.length,
                      ),
                    ),
                  );
          } else {
            return Center(
              child: Container(
                child: const Text(
                  "Loading...",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
