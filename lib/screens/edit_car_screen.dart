import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/car_state_service.dart';

class EditCarScreen extends StatefulWidget {
  final MobilClass car;

  const EditCarScreen({super.key, required this.car});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _brandNameController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _colorController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _detailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _brandNameController = TextEditingController(text: widget.car.brandName);
    _modelController = TextEditingController(text: widget.car.model);
    _yearController = TextEditingController(text: widget.car.year.toString());
    _colorController = TextEditingController(text: widget.car.color);
    _priceController = TextEditingController(text: widget.car.price.toString());
    _imageUrlController = TextEditingController(text: widget.car.imageUrl);
    _detailController = TextEditingController(text: widget.car.detail);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      MobilClass updatedCar = MobilClass(
        id: widget.car.id,
        createdAt: widget.car.createdAt,
        brandName: _brandNameController.text,
        model: _modelController.text,
        year: int.tryParse(_yearController.text) ?? widget.car.year,
        color: _colorController.text,
        price: int.tryParse(_priceController.text) ?? widget.car.price,
        imageUrl: _imageUrlController.text,
        detail: _detailController.text,
      );

      MobilClass? result = await context.read<CarStateService>().updateCarInApi(updatedCar);
      
      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car updated successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update car. Please try again.')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Car'),
      ),
      body: _isLoading
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
                      onPressed: _isLoading ? null : _submitForm,
                      child: const Text('Save Changes'),
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