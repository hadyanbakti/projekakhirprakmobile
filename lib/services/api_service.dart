import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekakhirprak/models/mobil_class.dart';

class ApiService {
  static const String _baseUrl = 'https://683d6237199a0039e9e540f7.mockapi.io/api/v1/brand';

  Future<List<MobilClass>> getCars() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<MobilClass> cars = body.map((dynamic item) => MobilClass.fromJson(item)).toList();
        return cars;
      } else {
        throw Exception('Failed to load cars from API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCars: $e');
      throw Exception('Failed to load cars: $e');
    }
  }

  Future<MobilClass?> addCar(MobilClass car) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(car.toJsonForCreation()), // Use toJsonForCreation here
      );
      if (response.statusCode == 201) { // 201 Created is typical for successful POST
        return MobilClass.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to add car. Status: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in addCar: $e');
      return null;
    }
  }

  Future<MobilClass?> updateCar(MobilClass car) async {
    if (car.id == null) {
      print('Error: Car ID is null, cannot update.');
      return null;
    }
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${car.id}'), // Append car ID to URL for PUT request
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(car.toJson()), // Use toJson() which includes id and createdAt if present
      );
      if (response.statusCode == 200) { // 200 OK is typical for successful PUT
        return MobilClass.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to update car. Status: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in updateCar: $e');
      return null;
    }
  }

  Future<bool> deleteCar(String carId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$carId'));
      if (response.statusCode == 200 || response.statusCode == 204) { // 200 or 204 No Content are typical for successful DELETE
        return true;
      } else {
        print('Failed to delete car. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in deleteCar: $e');
      return false;
    }
  }
} 