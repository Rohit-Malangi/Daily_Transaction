part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class AllTransactionEvent extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final String title;
  final num price;
  final DateTime chosenDate;

  AddTransactionEvent(this.title, this.price, this.chosenDate);
}

class DeleteTransactionEvent extends TransactionEvent {
  final num id;

  DeleteTransactionEvent(this.id);
}
