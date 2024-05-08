import 'package:choice/selection.dart';
import 'package:flutter/material.dart';

class ChoiceChipX<T> extends StatelessWidget {
  const ChoiceChipX({
    super.key,
    required this.label,
    required this.state,
    required this.value,
    this.onSelected
  });

  final String label;
  final ChoiceController<T> state;
  final T value;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ChoiceChip(
        label: Text(label),
        side: BorderSide.none,
        selected: state.selected(value),
        onSelected: onSelected ?? state.onSelected(value),
      ),
    );
  }
}
