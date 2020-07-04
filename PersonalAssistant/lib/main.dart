import 'package:PersonalAssistant/achievements/achievement.dart';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/goals/goals_list.dart';
import 'package:PersonalAssistant/todoapp/todoui.dart';
import 'package:PersonalAssistant/expense/mainExpense.dart';
import 'package:PersonalAssistant/password/screens/note_list.dart';
import 'package:PersonalAssistant/achievements/AcheivementUi.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:PersonalAssistant/birthday/birthdayMain.dart';
void main() => runApp(NewSplashScreen());


class NewSplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewSplashScreenState();
  }

}

class _NewSplashScreenState extends State<NewSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
		    
	    ),
      home:SplashScreen(
        seconds: 10,
        backgroundColor: Colors.black,
        loaderColor: Colors.transparent,
        image: Image.asset('images/splashScreen.gif'),
        
        title:  Text(
          'Personal Assistant',
          style: TextStyle(
            fontSize: 30.0,
            decorationColor: Colors.green,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            shadows:<Shadow>[
              Shadow(
                blurRadius: 18.0,
                color: Colors.blueGrey,
                offset: Offset.fromDirection(120, 12),
              ),
            ],
          ),
        ),
        photoSize: 200,
        navigateAfterSeconds: MyApp(),
      ),
    );
  }

}
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Personal Assistant'),
        ),
      body: Builder(
        builder: (context) => Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Goals'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => goalsList())),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('To do Tasks'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => todoui())),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.blueGrey,
                  child: Text('Expense'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => MyAppExpense())),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Password'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => NoteList())),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Achievement'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => AchievementPage())),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left:10.0, right: 10.0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Birthday'),
                  onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => BirthdayMain())),
                ),
              ),
            ],
          ),
        )
      ),
      );
    //);
  }
  Scaffold homeView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Assistant'
        ),
        elevation: 10.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child: Container(
                child: Text(
                  'Birthday',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Birthday tapped');
              },
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'Achievements',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Achievement tapped');
              },
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'Goals',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Goals tapped');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => goalsList()));
              },
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'To do Tasks',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Tasks tapped');
              },
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'Password',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Password tapped');
              },
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'Expense Manager',
                  style: TextStyle(),
                ),
              ),
              onTap: () {
                debugPrint('Expense tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}