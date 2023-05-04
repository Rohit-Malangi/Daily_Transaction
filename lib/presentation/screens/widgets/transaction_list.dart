import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../logic/bloc/transaction_bloc.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          print('state is $state');
      if (state is TransactionInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TransactionAll ||
          state is TransactionAdd ||
          state is TransactionDelete) {
        return state.list.isEmpty
            ? Expanded(
              child: Center(
                  child: Container(
                    child: const Text(
                      "No transaction added yet!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            )
            : Container(
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
                                  'Rs. ${state.list[index].price.toStringAsFixed(0)}',
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            state.list[index].name,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          subtitle: Text(
                            DateFormat.yMMMd().format(state.list[index].date),
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: MediaQuery.of(context).size.width > 400
                              ? TextButton.icon(
                                  onPressed: () => context
                                      .read<TransactionBloc>()
                                      .add(DeleteTransaction(
                                          state.list[index].id)),
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
                                  onPressed: () => context
                                      .read<TransactionBloc>()
                                      .add(DeleteTransaction(
                                          state.list[index].id)),
                                ),
                        ),
                      );
                    },
                    itemCount: state.list.length,
                  ),
                ),
              );
      } else {
        return Center(
          child: Container(
            child: const Text(
              "Unknown Error Occured...",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    });
  }
}
