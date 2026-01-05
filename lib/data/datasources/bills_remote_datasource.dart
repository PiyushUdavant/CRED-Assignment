import 'dart:convert';
import 'dart:developer' as dev;
import 'package:cred_application/core/strings.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:http/http.dart' as http;

abstract class BillsRemoteDataSource {
  Future<BillSectionModel> getBills(String endpoint);
}

class BillsRemoteDataSourceImpl implements BillsRemoteDataSource {
  final http.Client client;

  BillsRemoteDataSourceImpl(this.client);

  @override
  Future<BillSectionModel> getBills(String endpoint) async{
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
    ).timeout(const Duration(seconds: 30));

    if(response.statusCode == 200){
      try{
        final jsonData = json.decode(response.body);
        Map<String, dynamic> dataToParse;
        if (jsonData is Map<String, dynamic>) {
          if(jsonData.containsKey('data') && jsonData['data'] is
            Map) {
            dataToParse = jsonData['data'] as Map<String,dynamic>;
          }
          else{
            dataToParse = jsonData;
          }
        } else {
          throw Exception('Response is not a valid JSON object');
        }
        
        return BillSectionModel.fromJson(dataToParse);
      } catch(e) {
        dev.log('BillsRemoteDataSource: Error parsing JSON: $e');
        rethrow;
      }
    } else {
      throw Exception('Failed to load bills: ${response.statusCode}');
    }
  }
}