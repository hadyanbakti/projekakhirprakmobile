import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/car_state_service.dart';
import 'package:projekakhirprak/widgets/mobil_card.dart';
import 'package:projekakhirprak/screens/add_car_screen.dart';
import 'package:projekakhirprak/screens/edit_car_screen.dart';


class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  void _navigateToAddCarScreen(BuildContext context) async {
    // AddCarScreen will use Provider to add the car
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCarScreen()),
    );
    // Refresh is handled by CarStateService after successful add
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<CarStateService>(
        builder: (context, carState, child) {
          if (carState.isLoading && carState.garageCars.isEmpty) {
            // ProgressIndicatorThemeData in main.dart will style this
            return const Center(child: CircularProgressIndicator());
          } else if (carState.errorMessage != null && carState.garageCars.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading garage cars',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      carState.errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    // ElevatedButtonThemeData will style this button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => carState.refreshCars(),
                      label: const Text('Retry'),
                    )
                  ],
                ),
              )
            );
          } else if (carState.garageCars.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.garage_outlined, color: Colors.grey[400], size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Your garage is empty.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the \'+\' button to add your first car!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<MobilClass> cars = carState.garageCars;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Add some padding to the list
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return MobilCard(
                  car: car,
                  onEdit: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCarScreen(car: car),
                      ),
                    );
                  },
                  actionButtonType: MobilCardActionButtonType.moveToExhibition,
                  onAction: () {
                    context.read<CarStateService>().moveToExhibition(car.id!);
                  },
                  onDelete: () {
                    context.read<CarStateService>().deleteCarFromApi(car.id!);
                  }
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddCarScreen(context),
        tooltip: 'Add Car',
        // backgroundColor will be themed by colorScheme.secondary if not specified
        // or by floatingActionButtonTheme in ThemeData
        child: const Icon(Icons.add),
      ),
    );
  }
} 