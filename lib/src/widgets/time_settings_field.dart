import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSettingsField extends StatelessWidget {
  final String label;
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const TimeSettingsField({
    super.key,
    required this.label,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TimeUnitPicker(
                value: duration.inMinutes,
                label: 'Minutes',
                onChanged: (minutes) {
                  onChanged(Duration(
                    minutes: minutes,
                    seconds: duration.inSeconds % 60,
                  ));
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TimeUnitPicker(
                value: duration.inSeconds % 60,
                label: 'Seconds',
                maxValue: 59,
                onChanged: (seconds) {
                  onChanged(Duration(
                    minutes: duration.inMinutes,
                    seconds: seconds,
                  ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeUnitPicker extends StatefulWidget {
  final int value;
  final String label;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _TimeUnitPicker({
    required this.value,
    required this.label,
    required this.onChanged,
    this.maxValue = 99,
  });

  @override
  State<_TimeUnitPicker> createState() => _TimeUnitPickerState();
}

class _TimeUnitPickerState extends State<_TimeUnitPicker> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString().padLeft(2, '0'));
  }

  @override
  void didUpdateWidget(_TimeUnitPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.value != int.tryParse(_controller.text)) {
      _controller.text = widget.value.toString().padLeft(2, '0');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleValueChange(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null && newValue >= 0 && newValue <= widget.maxValue) {
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_drop_up),
            onPressed: widget.value < widget.maxValue
                ? () => widget.onChanged(widget.value + 1)
                : null,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _isEditing
                  ? TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: _handleValueChange,
                      onSubmitted: (value) {
                        setState(() {
                          _isEditing = false;
                        });
                        _handleValueChange(value);
                      },
                      onTapOutside: (_) {
                        setState(() {
                          _isEditing = false;
                        });
                        _handleValueChange(_controller.text);
                      },
                      autofocus: true,
                    )
                  : Text(
                      widget.value.toString().padLeft(2, '0'),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: widget.value > 0
                ? () => widget.onChanged(widget.value - 1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
} 