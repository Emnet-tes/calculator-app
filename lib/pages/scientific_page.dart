import 'dart:math' as math;
import 'package:calculator/components/button.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class ScientificPage extends StatefulWidget {
  const ScientificPage(
      {super.key, required this.isSwitched, required this.onSwitchChanged});

  final bool isSwitched;
  final Function(bool) onSwitchChanged;
  @override
  State<ScientificPage> createState() => _ScientificPageState();
}

class _ScientificPageState extends State<ScientificPage> {
  String input = '';
  String inputforUser = '';
  String result = '';
  final List<String> buttons = [
    'log',
    'ln',
    'csc',
    'sec',
    'cot',
    '(',
    ')',
    'sin',
    'cos',
    'tan',
    'π',
    '!',
    '√',
    '%',
    '*',
    '^',
    '7',
    '8',
    '9',
    '/',
    'Ans',
    '4',
    '5',
    '6',
    '-',
    'C',
    '1',
    '2',
    '3',
    '+',
    'del',
    'e',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          title: Text('Scientific'),
          leading: PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: Text('Standard'),
                      onTap: () => {
                            Navigator.pop(context),
                          }),
                  PopupMenuItem(
                    child: Text('Scientific'),
                    onTap: () => {},
                  ),
                ];
              }),
          actions: [
            Switch(
              value: widget.isSwitched,
              onChanged: widget.onSwitchChanged,
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    inputforUser,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    final value = buttons[index];
                    final op = isOperator(value);
                    final buttonChoice = op
                        ? Colors.blueAccent[700]
                        : (index == 20 || index == 25 || index == 30)
                            ? Colors.grey[500]
                            : buttonColor;
                    return Button(
                      color: buttonChoice,
                      textColor: op ? Colors.white : buttonTextColor,
                      text: buttons[index],
                      buttonTapped: () => {
                        if (index == 20)
                          {handelAns(value)}
                        else if (index == 25)
                          {input = '', inputforUser = '', result = ''}
                        else if (index == 30)
                          {
                            input = input.substring(0, input.length - 1),
                            inputforUser = inputforUser.substring(
                                0, inputforUser.length - 1)
                          }
                        else if (index == 34)
                          {
                            // result
                            equalTapped()
                          }
                        else
                          {
                            input += value, inputforUser += value},
                        setState(() {})
                      },
                    );
                  }))
        ]));
  }

  void equalTapped() {
    try {
      
      ContextModel cm = ContextModel();
      var E = Variable('e');
      var pi = Variable('π');
      cm.bindVariable(pi, Number(math.pi));
      cm.bindVariable(E, Number(math.e));
      Parser p = Parser();
      Expression exp = p.parse(input);
      double ans = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = ans.toString();
      });
    } catch (e) {
      result = 'Invalid Input';
    }
  }

  handelAns(value) {
    if (result.isEmpty) {
      result = 'No Input';
    } else if (inputforUser.contains('Ans')) {
      inputforUser += value;
      input += result;
    } else {
      inputforUser = value;
      input = result;
    }
  }
}
