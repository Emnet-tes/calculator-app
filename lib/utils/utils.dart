bool isOperator(String value) {
  return value == '+' ||
      value == '-' ||
      value == '*' ||
      value == '/' ||
      value == '=';
}

bool isNum(String value) {
  return int.tryParse(value) != null;
}
