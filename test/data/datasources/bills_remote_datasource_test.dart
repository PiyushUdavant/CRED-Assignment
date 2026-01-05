import 'dart:convert';
import 'package:cred_application/core/strings.dart';
import 'package:cred_application/data/datasources/bills_remote_datasource.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'bills_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late BillsRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = BillsRemoteDataSourceImpl(mockClient);
  });

  group('BillsRemoteDataSource', () {
    test(
      'should return BillSectionModel when API call is successful',
      () async {
        final jsonResponse = {
          'data': {
            'external_id': 'test_id',
            'template_properties': {
              'body': {
                'title': 'Test Bills',
                'bills_count': '5',
                'auto_scroll_enabled': true,
              },
            },
            'child_list': [],
          },
        };

        final uri = Uri.parse('$baseUrl$mock1Endpoint');

        when(
          mockClient.get(uri),
        ).thenAnswer((_) async => http.Response(jsonEncode(jsonResponse), 200));

        final result = await dataSource.getBills(mock1Endpoint);

        expect(result, isA<BillSectionModel>());
        expect(result.externalId, 'test_id');
        expect(result.title, 'Test Bills');
        expect(result.billsCount, '5');
        verify(mockClient.get(uri)).called(1);
      },
    );

    test(
      'should throw exception when API call fails with non-200 status',
      () async {
        final uri = Uri.parse('$baseUrl$mock1Endpoint');

        when(
          mockClient.get(uri),
        ).thenAnswer((_) async => http.Response('Error', 404));

        expect(
          () => dataSource.getBills(mock1Endpoint),
          throwsA(isA<Exception>()),
        );
      },
    );

    test('should parse JSON with data wrapper correctly', () async {
      final jsonResponse = {
        'data': {
          'external_id': 'test_id',
          'template_properties': {
            'body': {
              'title': 'Test',
              'bills_count': '3',
              'auto_scroll_enabled': false,
            },
          },
          'child_list': [],
        },
      };

      final uri = Uri.parse('$baseUrl$mock1Endpoint');

      when(
        mockClient.get(uri),
      ).thenAnswer((_) async => http.Response(jsonEncode(jsonResponse), 200));

      final result = await dataSource.getBills(mock1Endpoint);

      expect(result.externalId, 'test_id');
    });
  });
}
