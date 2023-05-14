import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../data/model/transaction.dart';
import '../../data/repository/TxProvider.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<AllTransactionEvent>((event, emit) async {
      try {
        await TxProvider()
            .alltransaction
            .then((value) => emit(TransactionAllState(value)));
      } catch (e) {
        emit(TransactionErrorState(e.toString()));
      }
    });

    on<AddTransactionEvent>((event, emit) async {
      try {
        await TxProvider()
            .addTransaction(event.title, event.price, event.chosenDate)
            .then((int id) async {
          await TxProvider()
              .alltransaction
              .then((value) => emit(TransactionAllState(value)));
        });
      } catch (e) {
        emit(TransactionErrorState(e.toString()));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      try {
        await TxProvider().deleteTransaction(event.id).then((value) async {
          await TxProvider()
              .alltransaction
              .then((value) => emit(TransactionAllState(value)));
        });
      } catch (e) {
        emit(TransactionErrorState(e.toString()));
      }
    });
  }
}
