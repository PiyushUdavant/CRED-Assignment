import 'package:bloc_test/bloc_test.dart';
import 'package:cred_application/core/strings.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/presentation/bloc/bills_bloc.dart';
import 'package:cred_application/presentation/screens/bills_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockBillsBloc extends MockBloc<BillsEvent, BillsState>
    implements BillsBloc {}

void main() {
  late MockBillsBloc mockBillsBloc;

  setUp(() {
    mockBillsBloc = MockBillsBloc();
  });

  tearDown(() {
    mockBillsBloc.close();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<BillsBloc>.value(
        value: mockBillsBloc,
        child: const BillsPage(endpoint: mock1Endpoint),
      ),
    );
  }

  testWidgets('should show loading indicator when state is BillsLoading', (
    tester,
  ) async {
    whenListen(
      mockBillsBloc,
      Stream.value(const BillsLoading()),
      initialState: const BillsLoading(),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when state is BillsFailure', (
    tester,
  ) async {
    whenListen(
      mockBillsBloc,
      Stream.value(const BillsFailure(message: 'Network error')),
      initialState: const BillsFailure(message: 'Network error'),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('Error: Network error'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('should show bills when state is BillsLoaded', (tester) async {
    final billSection = BillSectionModel(
      externalId: 'test_id',
      title: 'My Bills',
      billsCount: '5',
      autoScrollEnabled: true,
      cards: [],
    );

    whenListen(
      mockBillsBloc,
      Stream.value(BillsLoaded(billSection: billSection)),
      initialState: BillsLoaded(billSection: billSection),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('My Bills (5)'), findsOneWidget);
  });
}
