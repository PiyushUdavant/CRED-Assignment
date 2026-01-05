import 'package:cred_application/data/models/bill_section_model.dart';

abstract class BillsRepository {
  Future<BillSectionModel> getBills(String endpoint);
}