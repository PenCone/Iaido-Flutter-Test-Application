import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iaido_test_application/pages.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

// import 'package:google_fonts/google_fonts.dart';
// import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onTap: _handleUserInteraction,
      // onPanDown: _handleUserInteraction,
      child: GetMaterialApp(
        title: 'MoneyApp',
        theme: ThemeData(
          primarySwatch: colours,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // textTheme: GoogleFonts.latoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

const MaterialColor colours = const MaterialColor(
  0xFFDE0607,
  const <int, Color>{
    50: const Color(0xFFF7F7F7), //
    100: const Color(0xFFF9E6F3), //
    200: const Color(0xFFC0028B), //
    300: const Color(0xFFB0B3B8), //
    400: const Color(0xFFE4E6EB), //
    500: const Color(0xFF3A3B3C), //
    600: const Color(0xFF242526), //
    700: const Color(0xFF18191A), //
    800: const Color(0xFFC0028B), //
    900: const Color(0xFFC0028B), //
  },
);

String currency = "£";
double balance = 0.00; // integers, decimal

class MyHomePage extends StatefulWidget {
  MyHomePage({key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var transactions;

class _MyHomePageState extends State<MyHomePage> {
  List tactions = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    return data["objects"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      backgroundColor: colours[50],
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Top Section
              Stack(
                children: <Widget>[
                  // Pink Background with Balance
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: colours[200],
                    ),
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
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
                                text: "${balance.toInt()}",
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
                                text: balance.toStringAsFixed(2).split('.')[1],
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
                  // Raised Button Box (Pay, Top Up)
                  Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        // To add the raised box look
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0.0, 2)),
                        ],
                      ),
                      // For the icon buttons
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => TopUpPage());
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // borders used for design process to get alignment right
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Colors.red,
                                      //   ),
                                      // ),
                                      child: Image.asset(
                                          "assets/images/pay-icon.png"),
                                    ),
                                    Text(
                                      "Pay",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Colors.red,
                                      //   ),
                                      // ),
                                      child: Image.asset(
                                          "assets/images/top-up-icon.png"),
                                    ),
                                    Text(
                                      "Top Up",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Section
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.025),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Recent Activity Text
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.025),
                      child: Text(
                        "Recent Activity",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Transaction
                            FutureBuilder(
                              future: readJson(),
                              builder: (context, data) {
                                if (data.hasError) {
                                  //in case if error found
                                  return Center(child: Text("${data.error}"));
                                } else if (data.hasData) {
                                  transactions = data.data as List<dynamic>;
                                  balance = 0.0;
                                  // for (int i = 0;
                                  //     i < transactions.length;
                                  //     i++) {
                                  //   balance +=
                                  //       double.parse(transactions[i][]["Amount"]);
                                  // }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    itemCount: transactions[0].length,
                                    itemBuilder:
                                        (BuildContext content, int index) {
                                      return TransactionDay(
                                          transactions[0].keys.elementAt(index),
                                          index);
                                    },
                                  );
                                } else {
                                  // show circular progress while data is getting fetched from json file
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
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

class Transaction extends StatefulWidget {
  final double amount;
  final String name;
  final int moneyIn;
  Transaction(this.amount, this.name, this.moneyIn);

  @override
  TransactionState createState() => new TransactionState();
}

class TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 15,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Icon
              Container(
                width: MediaQuery.of(context).size.width * 0.075,
                height: MediaQuery.of(context).size.width * 0.075,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                    color: colours[200],
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Icon(
                    Icons.local_mall,
                    color: Colors.white,
                  ),
                ),
              ),
              // Name of Transaction
              Container(
                child: Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Amount
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: RichText(
              text: TextSpan(
                text: widget.moneyIn == 1
                    ? "+${widget.amount.toInt()}"
                    : "${widget.amount.toInt()}",
                style: TextStyle(
                  color: widget.moneyIn == 1 ? colours[200] : Colors.black,
                  fontSize: 30,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ".",
                    style: TextStyle(
                      color: widget.moneyIn == 1 ? colours[200] : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: widget.amount.toStringAsFixed(2).split('.')[1],
                    style: TextStyle(
                      color: widget.moneyIn == 1 ? colours[200] : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int dayPurchaseInx = 1;

class TransactionDay extends StatefulWidget {
  TransactionDay(this.tdate, this.inx);
  final String tdate;
  final int inx;

  @override
  TransactionDayState createState() => new TransactionDayState();
}

class TransactionDayState extends State<TransactionDay> {
  @override
  Widget build(BuildContext context) {
    // if (widget.inx < transactions.length &&
    //     widget.tdate == transactions[widget.inx + 1]) {
    //   dayPurchaseInx++;
    // }
    // if (dayPurchaseInx > 1) {
    return new Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        children: <Widget>[
          // Day
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: Text(
              widget.tdate,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: colours[300],
                fontSize: 14,
              ),
            ),
          ),
          // Transaction
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions[0]["${widget.tdate}"].length,
            itemBuilder: (BuildContext content, int index) {
              return Transaction(
                  double.parse(
                      transactions[0]["${widget.tdate}"][index]["Amount"]),
                  transactions[0]["${widget.tdate}"][index]["Name"],
                  int.parse(
                      transactions[0]["${widget.tdate}"][index]["InOut"]));
            },
          ),
        ],
      ),
    );
    // } else {
    //   return new Container(
    //     margin: EdgeInsets.symmetric(
    //         vertical: MediaQuery.of(context).size.height * 0.01),
    //     child: Column(
    //       children: <Widget>[
    //         // Day
    //         Container(
    //           alignment: Alignment.centerLeft,
    //           margin: EdgeInsets.symmetric(
    //               horizontal: MediaQuery.of(context).size.width * 0.05,
    //               vertical: MediaQuery.of(context).size.height * 0.01),
    //           child: Text(
    //             widget.tdate,
    //             textAlign: TextAlign.left,
    //             style: TextStyle(
    //               color: colours[300],
    //               fontSize: 14,
    //             ),
    //           ),
    //         ),
    //         // Transaction
    //         ListView.builder(
    //           padding: EdgeInsets.zero,
    //           physics: NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           itemCount: 1,
    //           itemBuilder: (BuildContext content, int index) {
    //             return Transaction(
    //                 double.parse(transactions[widget.inx]["Amount"]),
    //                 transactions[widget.inx]["Name"],
    //                 int.parse(transactions[widget.inx]["InOut"]));
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }
}
