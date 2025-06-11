import 'package:flutter/material.dart';
import 'package:projekakhirprak/models/mobil_class.dart';
// import 'package:projekakhirprak/screens/edit_car_screen.dart'; // No longer needed for direct navigation

// Updated enum: Removed .delete as onDelete callback now controls delete button visibility
enum MobilCardActionButtonType {
  moveToExhibition,
  moveToGarage,
}

class MobilCard extends StatelessWidget {
  final MobilClass car;
  final VoidCallback? onEdit; // Callback for edit action
  final MobilCardActionButtonType? actionButtonType; // For move operations
  final VoidCallback? onAction; // For move operations
  final VoidCallback? onDelete; // Callback for delete action

  const MobilCard({
    super.key,
    required this.car,
    this.onEdit,
    this.actionButtonType,
    this.onAction,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<void> _showDeleteConfirmationDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete ${car.brandName} ${car.model}?'),
                  const Text('This action cannot be undone.', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close dialog
                  if (onDelete != null) {
                    onDelete!(); // Execute the delete callback
                  }
                },
              ),
            ],
          );
        },
      );
    }

    Widget buildActionButtons() {
      List<Widget> buttons = [];

      // Add Edit button if onEdit is provided
      if (onEdit != null) {
        buttons.add(
          TextButton.icon(
            icon: Icon(Icons.edit, size: 18, color: theme.colorScheme.secondary),
            label: Text('Edit', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary)),
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
        );
      }

      // Add Move button if actionButtonType is a move type and onAction is provided
      if ((actionButtonType == MobilCardActionButtonType.moveToExhibition ||
           actionButtonType == MobilCardActionButtonType.moveToGarage) &&
          onAction != null) {
        if (buttons.isNotEmpty) {
          buttons.add(const SizedBox(width: 8)); // Add spacing if Edit button exists
        }
        buttons.add(ElevatedButton.icon(
          icon: Icon(actionButtonType == MobilCardActionButtonType.moveToGarage ? Icons.garage_outlined : Icons.store, size: 18),
          label: Text(actionButtonType == MobilCardActionButtonType.moveToGarage ? 'To Garage' : 'To Exhibition'),
          onPressed: onAction,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
        ));
      }

      // Add Delete button if onDelete is provided
      if (onDelete != null) {
        if (buttons.isNotEmpty) {
          buttons.add(const SizedBox(width: 8)); // Add spacing if other buttons exist
        }
        buttons.add(ElevatedButton.icon(
          icon: Icon(Icons.delete_forever, size: 18, color: Colors.white),
          label: const Text('Delete'),
          onPressed: _showDeleteConfirmationDialog,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: theme.colorScheme.error, // Use error color for delete button
              foregroundColor: Colors.white,
              textStyle: theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
        ));
      }

      if (buttons.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: buttons,
        ),
      );
    }
    
    return Card(
      // Theme provides shape, margin, elevation
      clipBehavior: Clip.antiAlias, // Important for ensuring image corners are clipped
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          AspectRatio(
            aspectRatio: 16 / 9,
            child: car.imageUrl.isNotEmpty
                ? Image.network(
                    car.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.directions_car,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        size: 50,
                      ),
                    ),
                  ),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${car.brandName} ${car.model}',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('Year: ${car.year}', style: theme.textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Icon(Icons.color_lens_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('Color: ${car.color}', style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Rp ${car.price.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (car.detail.isNotEmpty)
                  Text(
                    car.detail,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                // Action Buttons
                buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
      // onTap for showing details dialog (can be kept or removed based on preference)
      // If keeping, ensure the dialog styling is also professional
      // For this redesign, the card itself shows most info, so dialog might be redundant
      // unless it shows *more* extensive details not on the card.
    );
  }
} 