import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/api_service.dart';
import 'package:projekakhirprak/services/car_state_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate mocks for ApiService
@GenerateMocks([ApiService])
import 'car_state_service_test.mocks.dart';

void main() {
  // Test suite for CarStateService
  group('CarStateService', () {
    late CarStateService carStateService;
    late MockApiService mockApiService;

    // Sample car for testing
    final car1 = MobilClass(
        id: '1',
        brandName: 'Toyota',
        model: 'Supra',
        year: 2022,
        color: 'Red',
        price: 70000,
        imageUrl: 'url1',
        detail: 'details1',
        createdAt: DateTime.now().toIso8601String());

    setUp(() {
      // Runs before each test
      mockApiService = MockApiService();
      carStateService = CarStateService(apiService: mockApiService);
      // Set initial mock values for SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial values are correct', () {
      expect(carStateService.allCars, []);
      expect(carStateService.isLoading, false);
      expect(carStateService.errorMessage, null);
    });

    test('fetchAllCars success', () async {
      // Arrange
      when(mockApiService.getCars()).thenAnswer((_) async => [car1]);
      
      // Act
      await carStateService.fetchAllCars();

      // Assert
      expect(carStateService.allCars.length, 1);
      expect(carStateService.allCars[0].model, 'Supra');
      expect(carStateService.isLoading, false);
      expect(carStateService.errorMessage, null);
      verify(mockApiService.getCars()).called(1); // Verify that the method was called
    });

    test('fetchAllCars handles exceptions', () async {
      // Arrange
      when(mockApiService.getCars()).thenThrow(Exception('Failed to fetch'));

      // Act
      await carStateService.fetchAllCars();

      // Assert
      expect(carStateService.allCars.isEmpty, true);
      expect(carStateService.errorMessage, isNotNull);
      expect(carStateService.errorMessage, 'Exception: Failed to fetch');
      expect(carStateService.isLoading, false);
      verify(mockApiService.getCars()).called(1);
    });

    test('moveToExhibition saves car ID and notifies listeners', () async {
      // Arrange: First, fetch cars so we have something to move.
      when(mockApiService.getCars()).thenAnswer((_) async => [car1]);
      await carStateService.fetchAllCars();
      expect(carStateService.exhibitionCars.isEmpty, true);

      // Act
      await carStateService.moveToExhibition(car1.id!);

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(carStateService.exhibitionCars.length, 1);
      expect(carStateService.exhibitionCars[0].id, car1.id);
      expect(prefs.getStringList('exhibitionCarIds'), contains(car1.id));
    });

    test('moveToGarage removes car ID and notifies listeners', () async {
      // Arrange: First, move a car to exhibition.
      when(mockApiService.getCars()).thenAnswer((_) async => [car1]);
      await carStateService.fetchAllCars();
      await carStateService.moveToExhibition(car1.id!);
      expect(carStateService.exhibitionCars.length, 1);

      // Act
      await carStateService.moveToGarage(car1.id!);

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(carStateService.exhibitionCars.isEmpty, true);
      expect(prefs.getStringList('exhibitionCarIds'), isNot(contains(car1.id)));
    });
  });
} 