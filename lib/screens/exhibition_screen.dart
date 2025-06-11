import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
import 'package:projekakhirprak/services/car_state_service.dart';
import 'package:projekakhirprak/widgets/mobil_card.dart';
import 'package:projekakhirprak/screens/edit_car_screen.dart';

class ExhibitionScreen extends StatelessWidget {
  const ExhibitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<CarStateService>(
        builder: (context, carState, child) {
          if (carState.isLoading && carState.exhibitionCars.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (carState.errorMessage != null && carState.exhibitionCars.isEmpty) {
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
                      'Error loading exhibition cars',
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
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => carState.refreshCars(),
                      label: const Text('Retry'),
                    )
                  ],
                ),
              )
            );
          } else if (carState.exhibitionCars.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car_filled_outlined, color: Colors.grey[400], size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'No cars available in the exhibition yet.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later or add cars to your garage and move them here!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<MobilClass> cars = carState.exhibitionCars;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return MobilCard(
                  car: car,
                  actionButtonType: MobilCardActionButtonType.moveToGarage,
                  onAction: () {
                    context.read<CarStateService>().moveToGarage(car.id!);
                  }
                );
              },
            );
          }
        },
      ),
    );
  }
} 