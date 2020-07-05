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
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text.rich(
              TextSpan(
                children:<TextSpan>[
                  TextSpan(
                    text: 'Cong.. !\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'You have Completed your Goal\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
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