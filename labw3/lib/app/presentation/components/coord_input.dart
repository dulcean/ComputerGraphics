import 'package:flutter/material.dart';

class BuildCoordinateInput extends StatefulWidget {
  final String label;
  final int initialValue;
  final Function(String) onChanged;

  const BuildCoordinateInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<BuildCoordinateInput> createState() => BuildCoordinateInputState();
}

class BuildCoordinateInputState extends State<BuildCoordinateInput> {
  Color _borderColor = Colors.white;

  void _handleInputChange(String value) {
    try {
      widget.onChanged(value);
      int.parse(value);
      setState(() {
        _borderColor = Colors.grey;
      });
    } catch (e) {
      setState(() {
        _borderColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        SizedBox(
          width: 50,
          child: TextField(
            cursorColor: Colors.white,
            onChanged: _handleInputChange,
            decoration: InputDecoration(
              hintText: widget.initialValue.toString(),
              hintStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _borderColor, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.purpleAccent),
          ),
        ),
      ],
    );
  }
}
