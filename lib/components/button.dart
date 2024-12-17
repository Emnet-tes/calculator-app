import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
  });

  final dynamic color;
  final Color textColor;
  final String text;
  final dynamic buttonTapped;
  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: buttonTapped,
      child:Padding(
        padding: EdgeInsets.all(5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: color,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20
                  ),
                ),
              ),
            ))));
  }
}
