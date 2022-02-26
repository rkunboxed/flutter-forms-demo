import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class ExampleOne extends StatefulWidget {
  const ExampleOne({Key? key}) : super(key: key);

  @override
  State<ExampleOne> createState() => _ExampleOneState();
}

class _ExampleOneState extends State<ExampleOne> {
  //unique key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example One'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              //TODO: explain textInputAction
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
                    return 'Three character minimum.';
                  }
                  return null;
                },
                //TODO: explain autovalidateMode
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nickname',
                ),
              ),
              //const SizedBox(height: 20),
              SubmitButton(_submit),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton(this.onSubmit, {Key? key}) : super(key: key);

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    //requires context from the Builder wrapping our TextButton
    Color getColor(BuildContext context) {
      if (Focus.of(context).hasPrimaryFocus) {
        return Colors.green;
      } else {
        return Theme.of(context).colorScheme.primaryVariant;
      }
    }

    return Focus(
      child: Builder(builder: (context) {
        //Need to put this in a builder to get the correct context when calling Focus.of(context)
        //More info in the docs: https://api.flutter.dev/flutter/widgets/Focus-class.html
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextButton(
            onPressed: onSubmit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(getColor(context)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20)),
              shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
            child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
          ),
        );
      }),
    );
  }
}
