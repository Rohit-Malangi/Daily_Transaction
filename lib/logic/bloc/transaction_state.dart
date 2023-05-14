part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionAllState extends TransactionState {
  final List<Transaction> list;
  TransactionAllState(this.list);
}

class TransactionErrorState extends TransactionState {
  final String error;
  TransactionErrorState(this.error);
}




