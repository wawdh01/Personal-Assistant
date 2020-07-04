import 'package:flutter/material.dart';
class displayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.gif'),
            fit: BoxFit.cover,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text.rich(
              TextSpan(
                children:<TextSpan>[
                  TextSpan(
                    text: 'Congrats.. !\n',
                    style: TextStyle(),
                  ),
                  TextSpan(
                    text: 'You have Completed your Goal\n',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}