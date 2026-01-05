import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/domain/usecases/get_bills_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final GetBillsUsecases getBillsUseCase;

  BillsBloc({required this.getBillsUseCase}) : super(const BillsInitial()) {
    on<LoadBillsEvent>((event, emit) async {
      emit(const BillsLoading());
      try {
        final response = await getBillsUseCase(
          GetBillsParams(endpoint: event.endpoint),
        );
        emit(BillsLoaded(billSection: response));
      } catch (e) {
        emit(BillsFailure(message: e.toString()));
      }
    });
  }
}