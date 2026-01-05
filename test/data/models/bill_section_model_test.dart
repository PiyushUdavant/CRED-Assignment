import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillSectionModel', () {
    test('should parse JSON correctly with all fields', () {
      final json = {
        'external_id': 'section_1',
        'template_properties': {
          'body': {
            'title': 'My Bills',
            'bills_count': '5',
            'auto_scroll_enabled': true,
            'cards_animation_config': {
              'count': 3,
              'delay': 100,
              'duration': '0.5',
            },
          },
        },
        'child_list': [
          {
            'external_id': 'card_1',
            'template_properties': {
              'body': {'title': 'Electricity Bill', 'payment_amount': '₹500'},
              'ctas': {
                'primary': {'title': 'Pay Now', 'background_color': '#FF0000'},
              },
            },
          },
        ],
        'ctas': {
          'primary': {'title': 'View All'},
        },
      };

      final result = BillSectionModel.fromJson(json);

      expect(result.externalId, 'section_1');
      expect(result.title, 'My Bills');
      expect(result.billsCount, '5');
      expect(result.autoScrollEnabled, true);
      expect(result.viewAllCtaTitle, 'View All');
      expect(result.cards.length, 1);
      expect(result.animationConfig, isNotNull);
      expect(result.animationConfig?.count, 3);
    });

    test('should throw exception when template_properties is missing', () {
      final json = {'external_id': 'section_1'};

      expect(() => BillSectionModel.fromJson(json), throwsA(isA<Exception>()));
    });

    test('should handle empty child_list', () {
      final json = {
        'external_id': 'section_1',
        'template_properties': {
          'body': {
            'title': 'My Bills',
            'bills_count': '0',
            'auto_scroll_enabled': false,
          },
        },
        'child_list': [],
      };

      final result = BillSectionModel.fromJson(json);

      expect(result.cards, isEmpty);
    });
  });
}
