part of 'bills_bloc.dart';

abstract class BillsState extends Equatable{
  const BillsState();

  @override
  List<Object?> get props => [];
}

class BillsInitial extends BillsState {
  const BillsInitial();
}

class BillsLoading extends BillsState {
  const BillsLoading();
}

class BillsLoaded extends BillsState {
  final BillSectionModel billSection;

  const BillsLoaded({required this.billSection});

  @override
  List<Object> get props => [billSection];
}

class BillsFailure extends BillsState {
  final String message;

  const BillsFailure({required this.message});

  @override
  List<Object> get props => [message];
}