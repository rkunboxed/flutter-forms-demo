import 'package:flutter/material.dart';

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
        //passes the current set of states for the button to our getColor method
        backgroundColor: MaterialStateProperty.resolveWith(getColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20)),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
      child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
    );
  }
}
