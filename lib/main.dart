import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  List<Icon> scoreKeep = [];
  QuizBrain quizbrain = new QuizBrain();
  void check(bool b) {
    final player = new AudioCache();
    if (quizbrain.getAns() == b) {
      score++;
      player.play('quiz_correct.mp3');
      scoreKeep.add(
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    } else {
      player.play('quiz_fail.mp3');
      scoreKeep.add(
        Icon(
          Icons.close,
          color: Colors.red,
        ),
      );
    }
  }

  void buttonpress(bool b) {
    setState(() {
      if (quizbrain.isFin()) {
        //pop upp
        Alert(
          context: context,
          content: Text(
            '$score/13',
            style: TextStyle(
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          title: "Quiz Has Ended",
          desc: "Your Score",
          buttons: [
            DialogButton(
                child: Text(
                  "RESTART",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  score = 0;
                  Navigator.pop(context);
                  reset();
                })
          ],
        ).show();
      } else {
        check(b);
        quizbrain.nextQues();
      }
    });
  }

  void reset() {
    setState(() {
      quizbrain.reset();
      scoreKeep.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizbrain.getQues(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.

                buttonpress(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                buttonpress(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeep,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
