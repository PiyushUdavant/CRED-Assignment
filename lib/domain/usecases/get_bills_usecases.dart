import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/domain/repository/bills_repository.dart';
import 'package:equatable/equatable.dart';

class GetBillsUsecases {
  final BillsRepository repository;

  GetBillsUsecases(this.repository);

  Future<BillSectionModel> call(GetBillsParams params){
    return repository.getBills(params.endpoint);
  }
}

class GetBillsParams extends Equatable {
  final String endpoint;

  const GetBillsParams({required this.endpoint});

  @override
  List<Object> get props => [endpoint];
}