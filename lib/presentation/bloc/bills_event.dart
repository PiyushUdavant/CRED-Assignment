part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBillsEvent extends BillsEvent {
  final String endpoint;

  const LoadBillsEvent({required this.endpoint});

  @override
  List<Object> get props => [endpoint];
}