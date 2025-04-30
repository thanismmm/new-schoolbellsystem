import 'package:flutter/material.dart';

class TimeList extends StatelessWidget {
  final String title;
  final TimeOfDay time;
  final Function(TimeOfDay) onUpdate;

  const TimeList({
    super.key,
    required this.title,
    required this.time,
    required this.onUpdate,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null) {
      onUpdate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time.format(context)),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () => _selectTime(context),
          ),
          ElevatedButton(
            onPressed: () {
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
