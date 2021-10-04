import 'package:flutter/material.dart';
import 'package:iaido_test_application/main.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:get/get.dart';

class TopUpPage extends StatefulWidget {
  TopUpPage({key}) : super(key: key);

  @override
  TopUpPageState createState() => TopUpPageState();
}

class TopUpPageState extends State<TopUpPage> {
  TextEditingController amountCont = TextEditingController();
  int amountInx = 0, amountD = 0;
  double amount = 0.00; // integers, decimal
  bool decimal = false;
  // int amountInt = 10;

  Widget numberButton(int number) {
    String t = "";
    int alt = 0;
    if (number < 10) {
      t = "$number";
      alt = 0;
    } else if (number == 11) {
      t = ".";
      alt = 1;
    } else if (number == 12) {
      t = "<";
      alt = 2;
    }
    return TextButton(
      onPressed: () {
        int temp = (amount.toStringAsFixed(2)).length;
        switch (alt) {
          case 0:
            setState(() {
              if (amountInx < (temp - 2)) {
                if (temp > 6) {
                  amount = (amount - (amount % 10));
                  amount += number;
                } else {
                  amount = (amount * 10) + number;
                  amountInx++;
                }
              } else if (amountInx == (temp - 1)) {
                amount = (amount - (amount % 1.0));
                amount = amount + (number / 10);
                amountInx++;
              } else {
                double a = (amount * 100) %
                    10; // this is calculated this way due to precision errors
                amount = amount - (a / 100);
                amount = amount + (number / 100);
                amountInx++;
              }
            });
            if (amountInx > temp) amountInx = temp;
            amount = double.parse(amount.toStringAsFixed(
                2)); // we do this because sometimes modulus on decimal places can cause precision errors, there's probably a more efficient way

            break;
          case 1:
            amountInx += 2;
            if (amountInx > temp) amountInx = temp;
            break;
          case 2:
            setState(() {
              if (amountInx < (temp - 2)) {
                amount = (amount - (amount % 10)) / 10;
                if (amountInx > 0) amountInx--;
              } else if (amountInx == (temp - 1)) {
              } else {
                if (((amount * 100) % 10) != 0)
                  amount = (amount - (amount % 0.1));
                else {
                  amountInx--;
                  amount = (amount - (amount % 1.0));
                  if (amountInx > 1) amountInx -= 2;
                }
              }
            });
            if (amountInx < 0) amountInx = 0;
            amount = double.parse(amount.toStringAsFixed(2));

            break;
        }
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        overlayColor: MaterialStateProperty.all(colours[200].darken(10)),
        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width / 3,
        child: Center(
          child: Text(
            t,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.075,
                MediaQuery.of(context).size.width * 0.075,
              ),
            ),
            child: Icon(
              Icons.close,
              size: 24,
              color: colours[200],
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
        title: Center(
          // Page Title
          child: Text(
            "MoneyApp",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      backgroundColor: colours[200],
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(
                      //     vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // How Much
                          Container(
                            margin: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.025),
                            child: Text(
                              "How Much?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ),
                          // Amount
                          Container(
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: colours[200],
                            ),
                            child: Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height / 5,
                                width: MediaQuery.of(context).size.width / 2,
                                // decoration: BoxDecoration(
                                //   color: Colors.red,
                                // ),
                                alignment: Alignment.center,
                                // The Text needs to be customised to allow for different font sizes
                                // So RichText, TextSpan combo works well here for the use of children
                                child: RichText(
                                  text: TextSpan(
                                    text: "$currency",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "${amount.toInt()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 56,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ".",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 36,
                                        ),
                                      ),
                                      TextSpan(
                                        text: amount
                                            .toStringAsFixed(2)
                                            .split('.')[1],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 36,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Numpad
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              numberButton(1),
                              numberButton(2),
                              numberButton(3),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              numberButton(4),
                              numberButton(5),
                              numberButton(6),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              numberButton(7),
                              numberButton(8),
                              numberButton(9),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              numberButton(11), // decimal
                              numberButton(0),
                              numberButton(12), // backspace
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Next Button
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Color(0x7FF9E6F3), // default pink with 50% opacity
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.66,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: TextButton(
                        onPressed: () {
                          Get.off(() => WhoPage(amount: amount));
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          overlayColor: MaterialStateProperty.all(
                              colours[200].darken(10)),
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                        ),
                        child: Container(
                          child: Center(
                            child: Text(
                              "Next",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhoPage extends StatefulWidget {
  WhoPage({key, required this.amount}) : super(key: key);
  final double amount;

  @override
  WhoPageState createState() => WhoPageState();
}

class WhoPageState extends State<WhoPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.075,
                MediaQuery.of(context).size.width * 0.075,
              ),
            ),
            child: Icon(
              Icons.close,
              size: 24,
              color: colours[200],
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
        title: Center(
          // Page Title
          child: Text(
            "MoneyApp",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      backgroundColor: colours[200],
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // To Who
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.025),
                      child: Text(
                        "To Who?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    // Name
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.75,
                      // decoration: BoxDecoration(
                      //   color: colours[200],
                      // ),
                      child: new TextFormField(
                          onChanged: (text) {
                            print('First text field: $text');
                            name = text;
                          },
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 20,
                          cursorColor: colours[200].darken(20),
                          autofocus: false,
                          decoration: new InputDecoration(
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            hintText: 'Name',
                            hintStyle: TextStyle(color: colours[100]),
                            counterStyle: TextStyle(color: colours[100]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          )),
                    ),
                    // Pay Button
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Color(0x7FF9E6F3), // default pink with 50% opacity
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.66,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: TextButton(
                        onPressed: () {
                          if (name == "") {
                            Get.defaultDialog(
                              title: "Error",
                              middleText: "Please enter a name",
                              backgroundColor: colours[50],
                              titleStyle: TextStyle(color: Colors.black),
                              middleTextStyle: TextStyle(color: colours[200]),
                            );
                          } else {
                            int tm = transactions[0]["04 October"].length;
                            transactions[0]["04 October"][tm]["Amount"] =
                                widget.amount;
                            transactions[0]["04 October"][tm]["Name"] = name;
                            Get.offAll(() => MyHomePage());
                          }
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          overlayColor: MaterialStateProperty.all(
                              colours[200].darken(10)),
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                        ),
                        child: Container(
                          child: Center(
                            child: Text(
                              "Pay",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
