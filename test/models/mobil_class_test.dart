import 'package:flutter_test/flutter_test.dart';
import 'package:projekakhirprak/models/mobil_class.dart';

void main() {
  group('MobilClass', () {
    // Test case for MobilClass.fromJson
    group('fromJson', () {
      test('should correctly parse a valid JSON', () {
        // Arrange
        final json = {
          'id': '1',
          'createdAt': '2023-01-01T12:00:00Z',
          'brandName': 'Honda',
          'model': 'Civic',
          'year': 2021,
          'color': 'Black',
          'price': 25000,
          'imageUrl': 'http://example.com/civic.jpg',
          'detail': 'A reliable sedan.'
        };

        // Act
        final car = MobilClass.fromJson(json);

        // Assert
        expect(car.id, '1');
        expect(car.brandName, 'Honda');
        expect(car.model, 'Civic');
        expect(car.year, 2021);
        expect(car.price, 25000);
      });

      test('should handle string values for year and price', () {
        // Arrange
        final json = {
          'id': '2',
          'brandName': 'Tesla',
          'model': 'Model 3',
          'year': '2023',
          'color': 'White',
          'price': '40000',
          'imageUrl': 'http://example.com/model3.jpg',
          'detail': 'An electric car.'
        };

        // Act
        final car = MobilClass.fromJson(json);

        // Assert
        expect(car.year, 2023);
        expect(car.price, 40000);
      });
    });

    // Test case for MobilClass.toJsonForCreation
    group('toJsonForCreation', () {
      test('should produce a JSON map without id and createdAt', () {
        // Arrange
        final car = MobilClass(
          id: '1', // This should be ignored
          createdAt: '2023-01-01T12:00:00Z', // This should be ignored
          brandName: 'Ford',
          model: 'Mustang',
          year: 2022,
          color: 'Blue',
          price: 55000,
          imageUrl: 'http://example.com/mustang.jpg',
          detail: 'An iconic muscle car.'
        );

        // Act
        final json = car.toJsonForCreation();

        // Assert
        expect(json.containsKey('id'), isFalse);
        expect(json.containsKey('createdAt'), isFalse);
        expect(json['brandName'], 'Ford');
        expect(json['model'], 'Mustang');
      });
    });

    // Test case for MobilClass.toJson (for updates)
    group('toJson', () {
      test('should produce a JSON map including id and createdAt', () {
        // Arrange
        final car = MobilClass(
          id: '1',
          createdAt: '2023-01-01T12:00:00Z',
          brandName: 'Ford',
          model: 'Mustang',
          year: 2022,
          color: 'Blue',
          price: 55000,
          imageUrl: 'http://example.com/mustang.jpg',
          detail: 'An iconic muscle car.'
        );

        // Act
        final json = car.toJson();

        // Assert
        expect(json['id'], '1');
        expect(json['createdAt'], '2023-01-01T12:00:00Z');
        expect(json['brandName'], 'Ford');
      });
    });
  });
} 