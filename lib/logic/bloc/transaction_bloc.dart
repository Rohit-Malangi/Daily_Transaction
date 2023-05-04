import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../data/model/transaction.dart';
import '../../data/repository/TxProvider.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial([])) {
    on<AllTransaction>((event, emit) async {
      try {
        await TxProvider()
            .alltransaction
            .then((value) => emit(TransactionAll(value)));
      } catch (e) {
        emit(TransactionError([]));
      }
    });

    on<AddTransaction>((event, emit) async {
      try {
        await TxProvider()
            .addTransaction(event.title, event.price, event.chosenDate)
            .then((int id) {
          state.list.add(Transaction(
              name: event.title,
              price: event.price,
              date: event.chosenDate,
              id: id));
          emit(TransactionAdd(state.list));
        });
      } catch (e) {
        emit(TransactionError([]));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      try {
        await TxProvider().deleteTransaction(event.id).then((value) {
          state.list.removeWhere((element) => element.id == event.id);
          emit(TransactionDelete(state.list));
        });
      } catch (e) {
        emit(TransactionError([]));
      }
    });
  }
}
