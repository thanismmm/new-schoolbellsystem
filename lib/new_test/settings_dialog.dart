import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell_system/new_test/duration_field.dart';
import 'package:school_bell_system/new_test/schedule_provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController shortController;
  late TextEditingController longController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ScheduleProvider>(context, listen: false);
    shortController = TextEditingController(text: provider.shortBellDuration.toString());
    longController = TextEditingController(text: provider.longBellDuration.toString());
  }

  @override
  void dispose() {
    shortController.dispose();
    longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context, listen: true);
    return AlertDialog(
      title: const Text('System Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBellTypeSelector(provider),
            DurationTextField(
              label: 'Short Bell Duration',
              controller: shortController,
              min: 0,
              max: 10,
            ),
            DurationTextField(
              label: 'Long Bell Duration',
              controller: longController,
              min: 0,
              max: 20,
            ),
            _buildEmergencySwitch(provider),
            _buildBellModeSettings(provider),
            _buildAudioSettings(context, provider),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Validate and update provider only on save
            final shortValue = int.tryParse(shortController.text) ?? 0;
            final longValue = int.tryParse(longController.text) ?? 0;
            provider.updateShortBellDuration(shortValue.clamp(0, 10));
            provider.updateLongBellDuration(longValue.clamp(0, 20));
            await provider.saveScheduleToFirebase();
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildBellTypeSelector(ScheduleProvider provider) {
    return ListTile(
      title: const Text('Bell Type'),
      trailing: DropdownButton(
        value: provider.bellType,
        items: const [
          DropdownMenuItem(value: 10, child: Text("10")),
          DropdownMenuItem(value: 20, child: Text('20')),
          DropdownMenuItem(value: 30, child: Text('30')),
        ],
        onChanged: (value) => provider.updateBellType(value!),
      ),
    );
  }

  Widget _buildEmergencySwitch(ScheduleProvider provider) {
    return SwitchListTile(
      title: const Text('Emergency Ring'),
      value: provider.emergencyRing,
      onChanged: provider.toggleEmergencyRing,
    );
  }

  Widget _buildBellModeSettings(ScheduleProvider provider) {
    return Column(
      children: [
        _buildModeSelector(
          'Morning Bell Mode',
          'Controls the bell pattern at the start of the day',
          provider.morningBellMode,
          provider.updateMorningBellMode,
        ),
        _buildModeSelector(
          'Interval Bell Mode',
          'Controls the bell pattern during break periods',
          provider.intervalBellMode,
          provider.updateIntervalBellMode,
        ),
        _buildModeSelector(
          'Closing Bell Mode',
          'Controls the bell pattern at the end of the day',
          provider.closingBellMode,
          provider.updateClosingBellMode,
        ),
      ],
    );
  }

  Widget _buildModeSelector(
    String title,
    String description,
    List mode,
    Function(int, int) onUpdate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Text(
            title, 
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            SizedBox(width: 80, child: _buildLabeledModeDropdown('Ring Type', mode, 0, 5, onUpdate)),
            SizedBox(width: 80, child: _buildLabeledModeDropdown('Regular close', mode, 1, 7, onUpdate)),
            SizedBox(width: 80, child: _buildLabeledModeDropdown('Friday close', mode, 2, 5, onUpdate)),
            SizedBox(width: 80, child: _buildLabeledModeDropdown('Special', mode, 3, 5, onUpdate)),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildLabeledModeDropdown(
    String label,
    List mode,
    int index,
    int itemCount,
    Function(int, int) onUpdate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: 72,
          margin: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[200]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isExpanded: true,
                value: mode[index],
                items: List.generate(
                  itemCount,
                  (i) => DropdownMenuItem(
                    value: i, 
                    child: Text(
                      i.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                onChanged: (value) => onUpdate(index, value ?? mode[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioSettings(BuildContext context, ScheduleProvider provider) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          title: const Text('Regular Audio Files'),
          subtitle: Text(provider.audioList),
          onTap: () => _showEditDialog(
            context,
            'Regular Audio Files',
            provider.audioList,
            provider.updateAudioList,
          ),
        ),
        ListTile(
          title: const Text('Friday Audio Files'),
          subtitle: Text(provider.audioListF),
          onTap: () => _showEditDialog(
            context,
            'Friday Audio Files',
            provider.audioListF,
            provider.updateAudioListF,
          ),
        ),
      ],
    );
  }

  Future _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
