import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'dart:math' as Math;

double? width, height, displayHeight;
final fontSize32 = Device.get().isTablet ? 32 * 2.0 : 32.0;
final fontSize36 = Device.get().isTablet ? 36 * 2.0 : 36.0;
const MAX_FRACTION_DIGITS = 6;
final NumberFormat formatter = NumberFormat("#,###.######")
  ..maximumFractionDigits = 6;

var calculatorOperations = {
  '/': (prevValue, nextValue) => prevValue / nextValue,
  '*': (prevValue, nextValue) => prevValue * nextValue,
  '+': (prevValue, nextValue) => prevValue + nextValue,
  '-': (prevValue, nextValue) => prevValue - nextValue,
  '=': (prevValue, nextValue) => nextValue
};

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() {
    return CalculatorState();
  }
}

class CalculatorState extends State<Calculator> {
  String _history = ""; // This will store the previous expression

  var value;
  var displayValue = '0';
  var operator;
  var waitingForOperand = false;

  clearAll() {
    this.setState(() {
      value = null;
      displayValue = '0';
      operator = null;
      waitingForOperand = false;
      _history = "";
    });
  }

  clearDisplay() {
    this.setState(() {
      displayValue = '0';
    });
  }

  toggleSign() {
    var Value = double.parse(displayValue) * -1;

    this.setState(() {
      displayValue = formatter.format(Value).toString();
    });
  }

  inputPercent() {
    var currentValue = double.parse(displayValue);

    if (currentValue == 0) return;

    var fixedDigits = displayValue.replaceAll(RegExp(r"^-?\d*\.?"), '');
    var Value = double.parse(displayValue) / 100;

    this.setState(() {
      displayValue =
          formatter.format(Value.toStringAsFixed(fixedDigits.length + 2));
    });
  }

  inputDot() {
    if (!(RegExp(r"\.")).hasMatch(displayValue)) {
      this.setState(() {
        displayValue = displayValue + '.';
        waitingForOperand = false;
      });
    }
  }

  inputDigit(digit) {
    if (waitingForOperand) {
      this.setState(() {
        displayValue = digit.toString();
        waitingForOperand = false;
      });
    } else {
      this.setState(() {
        displayValue = displayValue == '0'
            ? digit.toString()
            : formatter.format(double.parse(
                (displayValue + digit.toString()).replaceAll(",", "")));
      });
    }
  }

  performOperation(nextOperator) {
    if (nextOperator != "=") {
      _history += displayValue + "${nextOperator}";
    } else {
      _history = "";
    }
    var inputValue = double.parse(displayValue.replaceAll(",", ""));

    if (value == null) {
      this.setState(() {
        value = inputValue;
      });
    } else if (operator != null) {
      var currentValue = value ?? 0;
      var Value = calculatorOperations[operator]!(currentValue, inputValue);

      this.setState(() {
        value = Value;
        displayValue = formatter.format(Value).toString();
      });
    }

    this.setState(() {
      waitingForOperand = true;
      operator = nextOperator;
    });
  }

  @override
  Widget build(BuildContext context) {
    var clearDisplay = displayValue != '0';
    var clearText = clearDisplay ? 'C' : 'AC';
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

    width = size.width - padding.horizontal;
    height = size.height - padding.top;

    width = Device.screenWidth - padding.horizontal;
    height = Device.screenHeight - padding.top;
    displayHeight =
        Math.max(height! - width! - width! / 5.0, fontSize32 + 15.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(fit: StackFit.expand, children: [
        Container(
          color: Color(0xFF1C191c),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CalculatorDisplay(value: displayValue, history: _history),
              Flexible(
                child: Row(
                  children: <Widget>[
                    FunctionKey(
                      text: clearText,
                      onPress: () =>
                          clearDisplay ? this.clearDisplay() : this.clearAll(),
                    ),
                    FunctionKey(
                      text: "±",
                      onPress: toggleSign,
                    ),
                    FunctionKey(
                      text: "%",
                      onPress: inputPercent,
                    ),
                    OperatorKey(
                      text: "÷",
                      onPress: () => this.performOperation('/'),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    DigitKey(
                      text: "7",
                      onPress: () => this.inputDigit(7),
                    ),
                    DigitKey(
                      text: "8",
                      onPress: () => this.inputDigit(8),
                    ),
                    DigitKey(
                      text: "9",
                      onPress: () => this.inputDigit(9),
                    ),
                    OperatorKey(
                      text: "×",
                      onPress: () => this.performOperation('*'),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    DigitKey(
                      text: "4",
                      onPress: () => this.inputDigit(4),
                    ),
                    DigitKey(
                      text: "5",
                      onPress: () => this.inputDigit(5),
                    ),
                    DigitKey(
                      text: "6",
                      onPress: () => this.inputDigit(6),
                    ),
                    OperatorKey(
                      text: "-",
                      onPress: () => this.performOperation('-'),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    DigitKey(
                      text: "1",
                      onPress: () => this.inputDigit(1),
                    ),
                    DigitKey(
                      text: "2",
                      onPress: () => this.inputDigit(2),
                    ),
                    DigitKey(
                      text: "3",
                      onPress: () => this.inputDigit(3),
                    ),
                    OperatorKey(
                      text: "+",
                      onPress: () => this.performOperation('+'),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    DigitKey(
                      text: "0",
                      onPress: () => this.inputDigit(0),
                    ),
                    DigitKey(
                      text: ".",
                      onPress: inputDot,
                      fontSize: fontSize32 * 2,
                    ),
                    OperatorKey(
                      text: "=",
                      onPress: () => this.performOperation('='),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            left: 5,
            top: MediaQuery.of(context).padding.top,
            child: SizedBox(
              width: 40,
              height: 40,
              child: ClipOval(
                child: CustomButton(
                    highlightColor: Colors.white54,
                    padding: EdgeInsets.all(0.0),
                    child: Center(
                        child: Icon(
                      Device.get().isIos
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ))
      ]),
    );
  }
}

class CalculatorDisplay extends StatelessWidget {
  final value;
  final history;

  const CalculatorDisplay({Key? key, this.value, this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: width,
        height: displayHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoSizeText(
                  history,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  value,
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorKey extends StatelessWidget {
  final String? text;
  final Function()? onPress;
  final Color? backgroundColor;
  final TextStyle? style;
  final bool isZeroKey;

  CalculatorKey(
      {Key? key, this.text, this.onPress, this.style, this.backgroundColor})
      : isZeroKey = text == '0',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: isZeroKey ? 2 : 1,
      child: CustomButton(
        padding: EdgeInsets.all(0),
        color: backgroundColor,
        highlightColor:
            Color.alphaBlend(Colors.white.withOpacity(0.5), backgroundColor!),
        onPressed: onPress,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                  top: BorderSide(color: Color(0xFF777777)),
                  right: BorderSide(color: Color(0xFF666666)))),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(right: isZeroKey ? width! / 4 : 0),
              child: Text(
                text!,
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionKey extends StatelessWidget {
  final text;
  final onPress;

  const FunctionKey({Key? key, this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalculatorKey(
      text: text,
      onPress: onPress,
      backgroundColor: Color.fromARGB(255, 116, 111, 111),
      style: TextStyle(color: Colors.white, fontSize: fontSize32),
    );
  }
}

class OperatorKey extends StatelessWidget {
  final text;
  final onPress;

  const OperatorKey({Key? key, this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalculatorKey(
      text: text,
      onPress: onPress,
      backgroundColor: Colors.orangeAccent,
      style: TextStyle(color: Colors.white, fontSize: fontSize36),
    );
  }
}

class DigitKey extends StatelessWidget {
  final text;
  final onPress;
  final fontSize;

  const DigitKey({Key? key, this.text, this.onPress, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalculatorKey(
      text: text,
      onPress: onPress,
      backgroundColor: Colors.blue,
      style: TextStyle(color: Colors.white, fontSize: fontSize ?? fontSize32),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color? highlightColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Function()? onPressed;

  const CustomButton({
    Key? key,
    this.highlightColor,
    this.padding,
    required this.child,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5.0),
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(padding),
        overlayColor: MaterialStateProperty.all(highlightColor),
      ),
    );
  }
}
