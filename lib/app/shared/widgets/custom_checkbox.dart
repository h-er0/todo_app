import 'package:flutter/material.dart';

//Custom checkbox widget
class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required this.isSelected,
    required this.onChanged,
  });
  final bool isSelected;
  final Function(bool? value) onChanged;

  @override
  State<CustomCheckbox> createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  void _toggleCheckbox() {
    /* setState(() {
      _isSelected = !_isSelected;
    }); */
    widget.onChanged(_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: _isSelected ? Colors.blue : null,
          border: _isSelected
              ? null
              : Border.all(width: 1.8, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _isSelected
            ? const Center(
                child: Icon(Icons.check_rounded, size: 17, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
