import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateScrollWidget extends StatefulWidget {
  final Function(String) onDateSelected; // Callback for selected date
  const DateScrollWidget({super.key, required this.onDateSelected});

  @override
  _DateScrollWidgetState createState() => _DateScrollWidgetState();
}

class _DateScrollWidgetState extends State<DateScrollWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep widget alive
  int selectedIndex = 3; // Default to today (middle of the list)

  List<Map<String, String>> getDateRange(int pastDays, int futureDays) {
    List<Map<String, String>> dateList = [];

    for (int i = -pastDays; i <= futureDays; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      String day = DateFormat('EEE').format(date); // "Mon", "Tue", etc.
      String formattedDate = DateFormat('MMM d').format(date); // "Mar 3", etc.

      dateList.add({
        "day": day,
        "date": formattedDate,
        "fullDate": DateFormat('yyyy-MM-dd').format(date),
      });
    }
    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> dateList = getDateRange(3, 7);
    return Container(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          bool isToday =
              dateList[index]["date"] ==
              DateFormat('MMM d').format(DateTime.now());

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // Notify the parent widget with the selected date
              widget.onDateSelected(dateList[index]["fullDate"]!);
            },
            child: Container(
              width: 52,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateList[index]["day"]!, // "Mon", "Tue", etc.
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w400,
                    ),
                  ),
                  Text(
                    isToday ? "Today" : dateList[index]["date"]!,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
