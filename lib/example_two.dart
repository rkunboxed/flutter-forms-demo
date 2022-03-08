import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forms_demo/custom_widgets/date_selector.dart';
import 'package:flutter_forms_demo/custom_widgets/dropdown_select.dart';
import 'package:flutter_forms_demo/custom_widgets/submit_button.dart';

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
              const SizedBox(height: 20),
              const Text('Requested Reservation Date'),
              const DateSelector(),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What is your favorite color?'),
                    DropdownSelect(
                      updateCallback: _setFavoriteColor,
                      options: _colorOptions,
                      validator: _validateFavoriteColor,
                    ),
                  ],
                ),
              ),
              CustomFormButton(buttonText: 'submit', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
  }
}
