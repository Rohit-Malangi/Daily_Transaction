part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {
  final List<Transaction> list;

  TransactionState(this.list);
}

class TransactionInitial extends TransactionState {
  TransactionInitial(List<Transaction> list) : super(list);
}

class TransactionAll extends TransactionState {
  TransactionAll(List<Transaction> list) : super(list);
}

class TransactionAdd extends TransactionState {
  TransactionAdd(List<Transaction> list) : super(list);
}

class TransactionDelete extends TransactionState {
  TransactionDelete(List<Transaction> list) : super(list);
}

class TransactionError extends TransactionState {
  TransactionError(List<Transaction> list) : super(list);
}




