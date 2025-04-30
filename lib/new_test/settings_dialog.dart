import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell_system/new_test/duration_field.dart';
import 'package:school_bell_system/new_test/schedule_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

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
            _buildDurationSettings(provider),
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
            await provider.saveScheduleToFirebase(); // Save to Firebase first
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
      trailing: DropdownButton<int>(
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

  Widget _buildDurationSettings(ScheduleProvider provider) {
    return Column(
      children: [
        DurationTextField(
          label: 'Short Bell Duration',
          initialValue: provider.shortBellDuration,
          onChanged: provider.updateShortBellDuration,
        ),
        DurationTextField(
          label: 'Long Bell Duration',
          initialValue: provider.longBellDuration,
          onChanged: provider.updateLongBellDuration,
        ),
      ],
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
          provider.morningBellMode,
          provider.updateMorningBellMode,
        ),
        _buildModeSelector(
          'Interval Bell Mode',
          provider.intervalBellMode,
          provider.updateIntervalBellMode,
        ),
        _buildModeSelector(
          'Closing Bell Mode',
          provider.closingBellMode,
          provider.updateClosingBellMode,
        ),
      ],
    );
  }

  Widget _buildModeSelector(
    String title,
    List<int> mode,
    Function(int, int) onUpdate,
  ) {
    return Column(
      children: [
        const Divider(),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(child: _buildModeDropdown(mode, 0, 2, onUpdate)),
            Expanded(child: _buildModeDropdown(mode, 1, 7, onUpdate)),
            Expanded(child: _buildModeDropdown(mode, 2, 5, onUpdate)),
          ],
        ),
      ],
    );
  }

  Widget _buildModeDropdown(
    List<int> mode,
    int index,
    int itemCount,
    Function(int, int) onUpdate,
  ) {
    return DropdownButton<int>(
      value: mode[index],
      items: List.generate(
        itemCount,
        (i) => DropdownMenuItem(value: i, child: Text(i.toString())),
      ),
      onChanged: (value) => onUpdate(index, value ?? mode[index]),
    );
  }

  Widget _buildAudioSettings(BuildContext context, ScheduleProvider provider) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          title: const Text('Regular Audio Files'),
          subtitle: Text(provider.audioList),
          onTap:
              () => _showEditDialog(
                context,
                'Regular Audio Files',
                provider.audioList,
                provider.updateAudioList,
              ),
        ),
        ListTile(
          title: const Text('Friday Audio Files'),
          subtitle: Text(provider.audioListF),
          onTap:
              () => _showEditDialog(
                context,
                'Friday Audio Files',
                provider.audioListF,
                provider.updateAudioListF,
              ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
