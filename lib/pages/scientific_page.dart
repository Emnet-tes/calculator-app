import 'dart:math';

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
    'C',
    '|x|',
    '1/x',
    '%',
    '*',
    '^',
    '7',
    '8',
    '9',
    '/',
    '√',
    '4',
    '5',
    '6',
    '-',
    'π',
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
                    input,
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
                        : (index == 10 || index == 30)
                            ? Colors.grey[500]
                            : buttonColor;
                    return Button(
                      color: buttonChoice,
                      textColor: op ? Colors.white : buttonTextColor,
                      text: buttons[index],
                      buttonTapped: () => {
                        if (index == 10)
                          {
                            setState(() {
                              input = '';
                              result = '';
                            })
                          }
                        else if (index == 30)
                          {
                            setState(() {
                              input = input.substring(0, input.length - 1);
                            })
                          }
                        else if (index == 34)
                          {
                            // result
                            {equalTapped()}
                          }
                        else
                          {
                            if (index == 25)
                              {
                                setState(() {
                                  input += pi.toString();
                                })
                              }
                            else if (index == 31)
                              {
                                setState(() {
                                  input += e.toString();
                                })
                              }
                            else
                              {
                                setState(() {
                                  input += value;
                                })
                              }
                          }
                      },
                    );
                  }))
        ]));
  }

  void equalTapped() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      // cm.bindVariable('π', Number(pi));
      // cm.bindVariable('e', Number(e));
      double ans = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = ans.toString();
      });
    } catch (e) {
      result = 'Invalid Input';
    }
  }
}
