import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'buttons/clear_button.dart';
import 'buttons/parentheses_button.dart';
import 'buttons/percent_button.dart';
import 'buttons/divide_button.dart';
import 'buttons/number_button.dart';
import 'buttons/multiply_button.dart';
import 'buttons/subtract_button.dart';
import 'buttons/add_button.dart';
import 'buttons/negate_button.dart';
import 'buttons/decimal_button.dart';
import 'buttons/equal_button.dart';
import 'buttons/delete_button.dart';
import 'game.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = "";
  String result = "0";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        userInput = "";
        result = "0";
      } else if (value == "=") {
        result = calculateResult(userInput);
      } else if (value == "+/-") {
        if (userInput[0] == "-") {
          userInput = userInput.substring(1);
        } else {
          userInput = "-$userInput";
        }
      } else if (value == "()") {
        int openCount = userInput.split('(').length - 1;
        int closeCount = userInput.split(')').length - 1;
        if (openCount > closeCount && userInput.isNotEmpty && RegExp(r'[0-9)]$').hasMatch(userInput)) {
          userInput += ")";
        } else {
          userInput += "(";
        }
      } else if (value == "%") {
        userInput += "%*";
      } else if (value == "÷") {
        userInput += "/";
      } else if (value == "x") {
        userInput += "*";
      } else if (value == "DEL") {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else {
        userInput += value;
      }
    });
  }

  String calculateResult(String input) {
    try {
      String formattedInput = input.replaceAll("%*", "/100*");
      Parser p = Parser();
      Expression exp = p.parse(formattedInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Hata!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(title: const Text("Hesap Makinesi")),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                userInput,
                style: const TextStyle(fontSize: 36, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(5),
              child: Text(
                result,
                style: const TextStyle(fontSize: 48, color: Color.fromARGB(255, 97, 219, 101)),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  child: const Text(
                    "Play",
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                DeleteButton(onPressed: () => buttonPressed("DEL")),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.156,
              ),
              itemBuilder: (context, index) {
                switch (buttons[index]) {
                  case "C":
                    return ClearButton(onPressed: () => buttonPressed(buttons[index]));
                  case "()":
                    return ParenthesesButton(onPressed: () => buttonPressed(buttons[index]));
                  case "%":
                    return PercentButton(onPressed: () => buttonPressed(buttons[index]));
                  case "÷":
                    return DivideButton(onPressed: () => buttonPressed(buttons[index]));
                  case "x":
                    return MultiplyButton(onPressed: () => buttonPressed(buttons[index]));
                  case "-":
                    return SubtractButton(onPressed: () => buttonPressed(buttons[index]));
                  case "+":
                    return AddButton(onPressed: () => buttonPressed(buttons[index]));
                  case "+/-":
                    return NegateButton(onPressed: () => buttonPressed(buttons[index]));
                  case ".":
                    return DecimalButton(onPressed: () => buttonPressed(buttons[index]));
                  case "=":
                    return EqualButton(onPressed: () => buttonPressed(buttons[index]));
                  default:
                    return NumberButton(text: buttons[index], onPressed: () => buttonPressed(buttons[index]));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> buttons = [
  "C","()","%","÷",
  "7","8","9","x",
  "4","5","6","-",
  "1","2","3","+",
  "+/-","0",".", "="
];