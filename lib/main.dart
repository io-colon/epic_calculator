import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Epic Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  //Vars
  String equation = "0";
  String result = "0";
  String expression = "";
  String memory = "0";

  void calculate() {
    expression = equation;
    expression = (expression.replaceAll('×', '*')).replaceAll("÷", "/");

    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);

      ContextModel cm = ContextModel();
      result = '${exp.evaluate(EvaluationType.REAL, cm)}';
    } catch (e) {
      result = "Error!";
    }
  }

  void pressed(String text) {
    setState(() {
    if (text == "C") {
      equation = "0";
      result = "0";
    } else if (text == "⌫") {
      equation = equation.substring(0, equation.length - 1);
      if (equation == "0") {
        equation = "0";
      }
    } else if (text == "=") {
      calculate();
    } else if (text == "M+") {
      memory = result;
    } else if (text == "M") {
      if (equation == "0") {
        equation = memory;
      } else {
        equation = equation + memory;
      }
    } else {
        if (equation == "0") {
          equation = text;
        } else {
          equation = equation + text;
        }
      }
    });
  }

  Widget calcButton(String text, double height, Color colour) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1 * height,
        child: RaisedButton(
            color: colour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            padding: EdgeInsets.all(16.0),
            onPressed: () => pressed(text),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            )));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epic Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(equation, style: TextStyle(fontSize: 38.0)), //Equation text
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(result, style: TextStyle(fontSize: 48.0)), // Result text
          ),
          Expanded(child: Divider()),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Table(
                children: [
                  TableRow(children: [
                    calcButton("M+", 1, Colors.redAccent),
                    calcButton("M", 1, Colors.redAccent),
                    calcButton("C", 1, Colors.redAccent),
                    calcButton("⌫", 1, Colors.redAccent),
                  ]),
                  TableRow(children: [
                    calcButton("7", 1, Colors.blue),
                    calcButton("8", 1, Colors.blue),
                    calcButton("9", 1, Colors.blue),
                    calcButton("+", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    calcButton("4", 1, Colors.blue),
                    calcButton("5", 1, Colors.blue),
                    calcButton("6", 1, Colors.blue),
                    calcButton("-", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    calcButton("1", 1, Colors.blue),
                    calcButton("2", 1, Colors.blue),
                    calcButton("3", 1, Colors.blue),
                    calcButton("×", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    calcButton(".", 1, Colors.blue),
                    calcButton("0", 1, Colors.blue),
                    calcButton("=", 1, Colors.green),
                    calcButton("÷", 1, Colors.black54),
                  ]),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
