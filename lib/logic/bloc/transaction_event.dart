part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class AllTransaction extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final String title;
  final num price;
  final DateTime chosenDate;
  
  AddTransaction(this.title, this.price, this.chosenDate);
}

class DeleteTransaction extends TransactionEvent {
  final num id;

  DeleteTransaction(this.id);
}
