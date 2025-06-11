import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/api_service.dart';

class CarStateService with ChangeNotifier {
  final ApiService apiService;
  static const String _exhibitionKey = 'exhibitionCarIds';

  List<MobilClass> _allCars = [];
  List<String> _exhibitionCarIds = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<MobilClass> get exhibitionCars => _allCars.where((car) => _exhibitionCarIds.contains(car.id)).toList();
  List<MobilClass> get garageCars => _allCars.where((car) => !_exhibitionCarIds.contains(car.id)).toList();
  List<MobilClass> get allCars => _allCars;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CarStateService({ApiService? apiService}) : apiService = apiService ?? ApiService();

  Future<void> _loadExhibitionCarIds() async {
    final prefs = await SharedPreferences.getInstance();
    _exhibitionCarIds = prefs.getStringList(_exhibitionKey) ?? [];
  }

  Future<void> _saveExhibitionCarIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_exhibitionKey, _exhibitionCarIds);
  }

  Future<void> fetchAllCars() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _loadExhibitionCarIds();
      _allCars = await apiService.getCars();
    } catch (e) {
      _errorMessage = e.toString();
      _allCars = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCars() async {
    await fetchAllCars();
  }

  Future<MobilClass?> addCarToApi(MobilClass car) async {
    _isLoading = true;
    notifyListeners();
    MobilClass? addedCar = await apiService.addCar(car);
    if (addedCar != null) {
      await fetchAllCars();
    } else {
      _isLoading = false;
      notifyListeners();
    }
    return addedCar;
  }

  Future<MobilClass?> updateCarInApi(MobilClass car) async {
    _isLoading = true;
    notifyListeners();
    MobilClass? updatedCar = await apiService.updateCar(car);
    if (updatedCar != null) {
      await fetchAllCars();
    } else {
      _isLoading = false;
      notifyListeners();
    }
    return updatedCar;
  }

  Future<bool> deleteCarFromApi(String carId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    bool success = false;
    try {
      success = await apiService.deleteCar(carId);
      if (success) {
        if (_exhibitionCarIds.contains(carId)) {
          _exhibitionCarIds.remove(carId);
          await _saveExhibitionCarIds();
        }
        await fetchAllCars();
      } else {
        _errorMessage = 'Failed to delete car from API.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      success = false;
    }
    return success;
  }

  Future<void> moveToExhibition(String carId) async {
    if (!_exhibitionCarIds.contains(carId)) {
      _exhibitionCarIds.add(carId);
      await _saveExhibitionCarIds();
      notifyListeners();
    }
  }

  Future<void> moveToGarage(String carId) async {
    if (_exhibitionCarIds.contains(carId)) {
      _exhibitionCarIds.remove(carId);
      await _saveExhibitionCarIds();
      notifyListeners();
    }
  }
} 