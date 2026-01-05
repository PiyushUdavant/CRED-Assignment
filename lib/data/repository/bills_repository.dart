import 'package:cred_application/data/datasources/bills_remote_datasource.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/domain/repository/bills_repository.dart' as domain;

class BillsRepositoryImpl implements domain.BillsRepository{
  final BillsRemoteDataSource remoteDataSource;

  BillsRepositoryImpl(this.remoteDataSource);

  @override
  Future<BillSectionModel> getBills(String endpoint){
    return remoteDataSource.getBills(endpoint);
  }
}