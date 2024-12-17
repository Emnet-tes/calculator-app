import 'package:calculator/components/button.dart';
import 'package:calculator/pages/scientific_page.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.isSwitched,
    required this.onSwitchChanged,
  });
  final bool isSwitched;
  final Function(bool) onSwitchChanged; // Callback to notify theme changes

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String input = '';
  String result = '';
  final List<String> buttons = [
    'C',
    '%',
    '!',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'del',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          title: Text('Standard'),
          leading: PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text('Standard'),
                  ),
                  PopupMenuItem(
                    child: Text('Scientific'),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScientificPage(
                                    isSwitched: widget.isSwitched,
                                    onSwitchChanged: widget.onSwitchChanged,
                                  )))
                    },
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
            flex: 2,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  final value = buttons[index];
                  final op = isOperator(value);
                  if (index == 0) {
                    return Button(
                      color: Colors.grey[500],
                      textColor: Colors.white,
                      text: buttons[index],
                      buttonTapped: () => {
                        setState(() {
                          input = '';
                          result = '';
                        })
                      },
                    );
                  }

                  if (index == 1 || index == 2) {
                    return Button(
                      color: Colors.grey[500],
                      textColor: Colors.white,
                      text: buttons[index],
                      buttonTapped: () => {
                        setState(() {
                          input += buttons[index];
                        })
                      },
                    );
                  }
                  if (index == 18) {
                    return Button(
                      color: buttonColor,
                      textColor: buttonTextColor,
                      text: buttons[index],
                      buttonTapped: () => {
                        setState(() {
                          input = input.substring(0, input.length - 1);
                        })
                      },
                    );
                  }

                  return Button(
                    color: op ? Colors.blueAccent[700] : buttonColor,
                    textColor: op ? Colors.white : buttonTextColor,
                    text: buttons[index],
                    buttonTapped: () => {
                      if (index == 19)
                        {equalTapped()}
                      else
                        {
                          setState(() {
                            input += buttons[index];
                          })
                        }
                    },
                  );
                }),
          )
        ]));
  }

  void equalTapped() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double ans = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = ans.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Invalid input';
      });
    }
  }
}
