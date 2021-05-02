import 'package:flutter/material.dart';
import 'package:flutter_app2/buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer  = '';
  var answer = '';
  //final myTextStyle = TextSytle(fontSize: 30, color: Colors.lightGreen[500]);

  final List<String> buttons =
  ['c', 'del', '%', '/',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '.', '0', 'ans', '=',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('🍃🌿 The Calculator 🌿🍃', style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.w200, color: Colors.lightGreen[900])),
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Column(
        children: <Widget> [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                        child: Container(
                        padding: EdgeInsets.all(30),
                        alignment: Alignment.centerLeft,
                        child: Text(userQuestion, style: GoogleFonts.gotu(fontSize: 30, color: Colors.lightGreen[800], fontWeight: FontWeight.w700)),
                        color: Colors.lightGreen[50],
                    ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                        padding: EdgeInsets.all(30),
                        alignment: Alignment.centerRight,
                        child: Text(userAnswer, style: GoogleFonts.gotu(fontSize: 30, color: Colors.lightGreen[800], fontWeight: FontWeight.w700)),
                        color: Colors.lightGreen[50],
                    ),
                  ),
                  )
                ],
              )
            ),
          ),
          Expanded(
            flex: 2,
              child: Container(
                child: GridView.builder(
                    padding: const EdgeInsets.all(25.0),
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index){
                      if(index == 0){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.lightGreen[800],
                          textColor: Colors.white,
                          buttonTapped: (){
                            setState(() {
                              userQuestion = '';
                              if (userAnswer != '') {
                                answer = userAnswer;
                              }
                              userAnswer = '';
                            });
                          },
                        );
                      } else if(index == 1){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.lightGreen[600],
                          textColor: Colors.white,
                          buttonTapped: (){
                            setState(() {
                              if (userQuestion != '') {
                                userQuestion = userQuestion.substring(
                                    0, userQuestion.length - 1);
                              }
                            });
                          },
                        );
                      } else if(index == buttons.length-1){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.lightGreen[400],
                          textColor: Colors.white,
                          buttonTapped: (){
                            setState(() {
                              equalPressed(answer);
                              answer = userAnswer;
                            });
                          },
                        );
                      } else if(index == buttons.length-2){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.lightGreen[400],
                          textColor: Colors.white,
                          buttonTapped: (){
                            setState(() {
                              userQuestion += buttons[index];
                              if (userAnswer != '') {
                                answer = userAnswer;
                              }
                            });
                          },
                        );
                      } else {
                        return MyButton(
                          buttonText: buttons[index],
                          color: isOperator(buttons[index]) ? Colors.lightGreen[400] : Colors.lightGreen[50],
                          textColor: isOperator(buttons[index]) ? Colors.white : Colors.lightGreen,
                          buttonTapped: (){
                            setState(() {
                              userQuestion += buttons[index];
                            });
                          },
                        );
                      }
                    }),
              ),
          )
        ]
      )
    );
  }

  bool isOperator(String x){
    if(x == '%' || x == '/' || x == '+' || x == '-' || x == '×' || x == '='){
      return true;
    }
    return false;
  }

  void equalPressed(answer) {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('×', '*');
    finalQuestion = finalQuestion.replaceAll('ans', answer);
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = 0.0;
    try {
      eval = exp.evaluate(EvaluationType.REAL, cm);
    } on ArgumentError catch(e) {
      userAnswer = 'Invalid input!';
    }

    if (eval % 1 == 0) {
      int newEval = eval.round();
      userAnswer = newEval.toString();
    }
    else {
      userAnswer = eval.toString();
    }
  }
}
