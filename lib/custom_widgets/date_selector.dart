import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//Custom Form Widget that uses Focus widget to handle styling
class DateSelector extends StatefulWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime today = DateTime.now();
  DateTime? selectedDate;
  BoxBorder borderStyle = Border.all(width: 1, color: Colors.grey);
  String displayText = 'Select Date';

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDate != null) {
      displayText = DateFormat('MMMM dd, yyyy').format(selectedDate!).toString();
    }

    return Focus(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _selectStartDate();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (bool focused) {
        setState(() {
          borderStyle = focused ? Border.all(width: 2, color: Colors.blue) : Border.all(width: 1, color: Colors.grey);
        });
      },
      child: GestureDetector(
        onTap: _selectStartDate,
        child: Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: borderStyle,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.today, color: Colors.blue),
              const SizedBox(width: 12),
              Builder(
                builder: (BuildContext context) {
                  // if you need to do anything based on the focus state of the parent you can do that
                  // in a builder (so you have a context)
                  final FocusNode focusNode = Focus.of(context);
                  Color textColor = Colors.grey;
                  if (focusNode.hasFocus) {
                    textColor = Colors.blue;
                  }
                  return Text(displayText, style: TextStyle(color: textColor));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
