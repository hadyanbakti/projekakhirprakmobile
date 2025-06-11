import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/car_state_service.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  // ApiService is no longer directly used here, CarStateService will handle it.

  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      MobilClass newCar = MobilClass(
        brandName: _brandNameController.text,
        model: _modelController.text,
        year: int.tryParse(_yearController.text) ?? 0,
        color: _colorController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        imageUrl: _imageUrlController.text,
        detail: _detailController.text,
      );

      // Use CarStateService to add the car
      MobilClass? addedCar = await context.read<CarStateService>().addCarToApi(newCar);

      // No need to manage _isLoading here if CarStateService handles its own loading state for this operation
      // However, for local button disabling, it might still be useful.
      // If CarStateService updates its isLoading state and notifies listeners, the consumer would rebuild.
      // For simplicity in this screen, we'll keep local _isLoading for the button.
      setState(() {
        _isLoading = false;
      });

      if (addedCar != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car added successfully!')),
        );
        Navigator.pop(context, true); // Return true to indicate success (GarageScreen will refresh via CarStateService)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add car. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Potentially listen to CarStateService's isLoading if it globally manages loading for add operations
    // final carStateIsLoading = context.watch<CarStateService>().isLoading; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Car'),
      ),
      body: _isLoading // Use local _isLoading for button state
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildTextFormField(_brandNameController, 'Brand Name'),
                    _buildTextFormField(_modelController, 'Model'),
                    _buildTextFormField(_yearController, 'Year', keyboardType: TextInputType.number),
                    _buildTextFormField(_colorController, 'Color'),
                    _buildTextFormField(_priceController, 'Price', keyboardType: TextInputType.number),
                    _buildTextFormField(_imageUrlController, 'Image URL'),
                    _buildTextFormField(_detailController, 'Details', maxLines: 3),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm, // Disable button when loading
                      child: const Text('Add Car'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if ((label == 'Year' || label == 'Price') && int.tryParse(value) == null) {
             return 'Please enter a valid number for $label';
          }
          return null;
        },
      ),
    );
  }
} 