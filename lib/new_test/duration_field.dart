import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationTextField extends StatefulWidget {
  final String label;
  final int initialValue;
  final Function(int) onChanged;

  const DurationTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DurationTextField> createState() => _DurationTextFieldState();
}

class _DurationTextFieldState extends State<DurationTextField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(DurationTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      trailing: SizedBox(
        width: 60,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            suffixText: 'sec',
          ),
          onChanged: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              widget.onChanged(intValue);
            }
          },
        ),
      ),
    );
  }
}