import 'package:calculator/components/button.dart';
import 'package:calculator/pages/scientific_page.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:eval_ex/expression.dart';

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
  String inputforUser = '';
  String result = '';
  final List<String> buttons = [
    'C',
    '%',
    'Ans',
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
            flex: 2,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  final value = buttons[index];
                  final op = isOperator(value);
                  final buttonChoice = op
                      ? Colors.blueAccent[700]
                      : (index < 4)
                          ? Colors.grey[500]
                          : buttonColor;
                  return Button(
                      color: buttonChoice,
                      textColor: op ? Colors.white : buttonTextColor,
                      text: buttons[index],
                      buttonTapped: () => {
                            if (index == 0)
                              {input = '', inputforUser = ''}
                            else if (index == 2)
                              {handelAns(value)}
                            else if (index == 18)
                              {handleDel()}
                            else if (index == 19)
                              {equalTapped()}
                            else
                              {input += value, inputforUser += value},
                            setState(() {})
                          });
                }),
          )
        ]));
  }

  void equalTapped() {
    try {
      Expression exp = Expression(input);
      var ans = exp.eval().toString();
      setState(() {
        if (ans.length > 15) {
          ans = ans.substring(0, 15);
        }
        result = ans;
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
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

  handleDel() {
    try {
      input = input.substring(0, input.length - 1);
      inputforUser = inputforUser.substring(0, inputforUser.length - 1);
    } catch (e) {
      result = 'No Input';
    }
  }
}
