import 'package:cred_application/core/strings.dart';
import 'package:cred_application/data/datasources/bills_remote_datasource.dart';
import 'package:cred_application/data/repository/bills_repository.dart';
import 'package:cred_application/domain/usecases/get_bills_usecases.dart';
import 'package:cred_application/presentation/bloc/bills_bloc.dart';
import 'package:cred_application/presentation/screens/bills_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final remoteDataSource = BillsRemoteDataSourceImpl(httpClient);
    final repository = BillsRepositoryImpl(remoteDataSource);
    final getBillsUseCase = GetBillsUsecases(repository);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRED Assignment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => BillsBloc(getBillsUseCase: getBillsUseCase),
        child: const BillsPage(
          endpoint: mock1Endpoint, // Change to mock2Endpoint for 9 items
        ),
      ),
    );
  }
}

