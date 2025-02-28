import 'package:flutter/material.dart';
import 'package:live_score_ke/widgets/bottom_sheet.dart';

void showRemoveTeamBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const RemoveTeamBottomSheet(),
  );
}
