import 'package:bloc_test/bloc_test.dart';
import 'package:cred_application/core/strings.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/domain/usecases/get_bills_usecases.dart';
import 'package:cred_application/presentation/bloc/bills_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bills_bloc_test.mocks.dart';

@GenerateMocks([GetBillsUsecases])
void main() {
  late BillsBloc billsBloc;
  late MockGetBillsUsecases mockGetBillsUseCase;

  setUp(() {
    mockGetBillsUseCase = MockGetBillsUsecases();
    billsBloc = BillsBloc(getBillsUseCase: mockGetBillsUseCase);
  });

  tearDown(() {
    billsBloc.close();
  });

  test('initial state should be BillsInitial', () {
    expect(billsBloc.state, equals(const BillsInitial()));
  });

  blocTest<BillsBloc, BillsState>(
    'emits [BillsLoading, BillsLoaded] when LoadBillsEvent is successful',
    build: () {
      when(mockGetBillsUseCase(any)).thenAnswer(
        (invocation) async {
          return BillSectionModel(
            externalId: 'test_id',
            title: 'Test Bills',
            billsCount: '5',
            autoScrollEnabled: true,
            cards: [],
          );
        },
      );
      return billsBloc;
    },
    act: (bloc) => bloc.add(const LoadBillsEvent(endpoint: mock1Endpoint)),
    expect: () => [
      const BillsLoading(),
      isA<BillsLoaded>(),
    ],
    verify: (_) {
      verify(mockGetBillsUseCase(any)).called(1);
    },
  );

  blocTest<BillsBloc, BillsState>(
    'emits [BillsLoading, BillsFailure] when LoadBillsEvent fails',
    build: () {
      when(mockGetBillsUseCase(any)).thenThrow(
        Exception('Network error'),
      );
      return billsBloc;
    },
    act: (bloc) => bloc.add(const LoadBillsEvent(endpoint: mock1Endpoint)),
    expect: () => [
      const BillsLoading(),
      isA<BillsFailure>(),
    ],
  );
}