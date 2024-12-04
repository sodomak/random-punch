import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberSettingsField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;
  final String? suffix;

  const NumberSettingsField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 99,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _NumberPicker(
          value: value,
          minValue: minValue,
          maxValue: maxValue,
          suffix: suffix,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _NumberPicker extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String? suffix;
  final ValueChanged<int> onChanged;

  const _NumberPicker({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.suffix,
  });

  @override
  State<_NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<_NumberPicker> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.value != int.tryParse(_controller.text)) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleValueChange(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null && 
        newValue >= widget.minValue && 
        newValue <= widget.maxValue) {
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
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _isEditing
                  ? TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.value.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (widget.suffix != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            widget.suffix!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: widget.value > widget.minValue
                ? () => widget.onChanged(widget.value - 1)
                : null,
          ),
        ],
      ),
    );
  }
} 