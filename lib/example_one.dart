import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_forms_demo/custom_widgets/submit_button.dart';

class ExampleOne extends StatefulWidget {
  const ExampleOne({Key? key}) : super(key: key);

  @override
  State<ExampleOne> createState() => _ExampleOneState();
}

class _ExampleOneState extends State<ExampleOne> {
  //unique key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example One')),
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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Field required.';
                  }
                  return null;
                },
                //use textInputAction to control action buttons on mobile keyboards
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Last Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Field required.';
                  }
                  if (value.length < 3) {
                    return 'Three character minimum.';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                //validate this field as the user types
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nickname',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              SubmitButton(_submit),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    //null safety check
    if (_formKey.currentState != null) {
      //calls validate on all the form elements
      //returns true if all the fields validate
      if (!_formKey.currentState!.validate()) {
        developer.log('FAILURE');
        return;
      }
      //calls "save" on all the form elements
      //_formKey.currentState!.save();
    }
    developer.log('SUCCESS');
  }
}
