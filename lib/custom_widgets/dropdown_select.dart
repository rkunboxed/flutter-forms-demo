import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownSelect extends StatefulWidget {
  const DropdownSelect({Key? key, required this.updateCallback, required this.options, this.initialVal, this.validator}) : super(key: key);

  final void Function(String) updateCallback;
  final List<String> options;
  final String? initialVal;
  final String? Function(dynamic)? validator;

  @override
  _DropdownSelectState createState() => _DropdownSelectState();
}

class _DropdownSelectState extends State<DropdownSelect> {
  String? _dropdownValue;
  double _borderWidth = 1;
  Color _borderColor = Colors.grey;
  final GlobalKey _popUpMenuKey = GlobalKey();

  void _updateValue(String value) {
    widget.updateCallback(value);

    setState(() {
      _dropdownValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialVal != null) {
      _dropdownValue = widget.initialVal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<dynamic>(
      validator: widget.validator,
      builder: (FormFieldState fieldState) {
        if (fieldState.hasError) {
          _borderColor = Theme.of(context).colorScheme.error;
        }

        return Column(
          children: [
            Focus(
              onKeyEvent: (node, event) {
                if (event.logicalKey == LogicalKeyboardKey.enter && _popUpMenuKey.currentState != null) {
                  final PopupMenuButtonState buttonState = _popUpMenuKey.currentState as PopupMenuButtonState;
                  buttonState.showButtonMenu();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              onFocusChange: (bool focused) {
                setState(() {
                  _borderWidth = focused ? 2 : 1;
                  _borderColor = focused ? Theme.of(context).colorScheme.primary : Colors.grey;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: _borderWidth, color: _borderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: PopupMenuButton<String>(
                  key: _popUpMenuKey,
                  onSelected: (value) {
                    _updateValue(value);
                    if (widget.validator != null) {
                      fieldState.validate();
                    }
                  },
                  initialValue: _dropdownValue,
                  itemBuilder: (BuildContext context) {
                    return widget.options.map<PopupMenuItem<String>>(
                      (String value) {
                        return PopupMenuItem<String>(
                          key: Key(value),
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 15)),
                        );
                      },
                    ).toList();
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(_dropdownValue ?? 'Select', style: const TextStyle(fontSize: 15.0)),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.primary, size: 30),
                    ],
                  ),
                ),
              ),
            ),
            if (fieldState.hasError && fieldState.errorText != null && fieldState.errorText!.isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(fieldState.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ),
              ),
          ],
        );
      },
    );
  }
}
