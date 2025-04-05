import 'package:flutter/material.dart';
import 'package:livescore_x/widgets/custom_filled_button.dart';

class RemoveTeamBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const RemoveTeamBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 333,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline, size: 36),
          const SizedBox(height: 16),
          Text(
            'Delete Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to terminate you account? This action is irreversible',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24),
          CustomFilledButton(onPressed: onConfirm, text: 'Confirm'),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
