import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({Key? key}) : super(key: key);

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {
  //unique key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _colorOptions = ['red', 'orange', 'yellow', 'green', 'blue', 'purple'];
  String? _favoriteColor;

  void _setFavoriteColor(String color) {
    _favoriteColor = color;
    developer.log('Favorite Color: $color');
  }

  String? _validateFavoriteColor(dynamic val) {
    if (_favoriteColor == null) {
      return 'Field required.';
    } else {
      return null;
    }
  }

  void _submit() {
    if (_formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) {
        developer.log('FAILURE');
        return;
      }
    }
    developer.log('SUCCESS');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Two'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'First Name',
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Field required.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Last Name',
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Field required.';
                  }
                  if (value.length < 3) {
                    return 'Minimum ';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nickname',
                ),
                textInputAction: TextInputAction.next,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What is your favorite color?'),
                    DropDownSelect(
                      updateCallback: _setFavoriteColor,
                      options: _colorOptions,
                      validator: _validateFavoriteColor,
                    ),
                  ],
                ),
              ),
              SubmitButton(_submit),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownSelect extends StatefulWidget {
  const DropDownSelect({Key? key, required this.updateCallback, required this.options, this.initialVal, this.validator}) : super(key: key);

  final void Function(String) updateCallback;
  final List<String> options;
  final String? initialVal;
  final String? Function(dynamic)? validator;

  @override
  _DropDownSelectState createState() => _DropDownSelectState();
}

class _DropDownSelectState extends State<DropDownSelect> {
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
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(fieldState.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ),
              ),
          ],
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton(this.onSubmit, {Key? key}) : super(key: key);

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    //Use MaterialStateProperty to specify the button color
    //example from: https://api.flutter.dev/flutter/material/MaterialStateProperty-class.html
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.green;
      }
      return Theme.of(context).colorScheme.primaryVariant;
    }

    return TextButton(
      onPressed: onSubmit,
      style: ButtonStyle(
        //passes the current set of states for the button to our method
        backgroundColor: MaterialStateProperty.resolveWith(getColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20)),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
      child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
    );
  }
}
