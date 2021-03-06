import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iaido_test_application/pages.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' as rootBundle;
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

List transactions = [];

// Fetch content from the json file
Future<void> readJson() async {
  final String response =
      await rootBundle.rootBundle.loadString('assets/data.json');
  final data = await json.decode(response);
  // return data["objects"];
  // transactions = data.data as List<dynamic>;
  return data["objects"];
}

class MyApp extends StatelessWidget {
  void initState() async {
    await readJson();
  }

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
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              SplashScreen(
                seconds:
                    2, // the widget to run after running your splashscreen for 2 sec
                navigateAfterSeconds: MyHomePage(),
                backgroundColor: colours[200],
                loaderColor: colours[100],
              ),
              Center(
                child: Container(
                  height: 250,
                  child: Text(
                    "MoneyApp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

String currency = "??";
double balance = 0.00; // integers, decimal

class MyHomePage extends StatefulWidget {
  MyHomePage({key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    transitionTimer();
  }

  // A Timer so the widgets fade in after 800ms
  transitionTimer() {
    Timer(Duration(milliseconds: 800), () {
      setState(() {
        _visible = true;
      });
    });
  }

  // This calculates the balance of the user by adding all the amount data in the json file
  Future<void> balanceCalc() async {
    balance = 0.0;
    if (transactions.length != 0) {
      print(transactions[0].keys.elementAt(0));
      for (var j in transactions[0].keys) {
        for (var k in transactions[0][j]) {
          print("Date : $j, Amount : ${k["Amount"]}, In: ${k["InOut"]}");
          if (k["InOut"] == "1")
            balance += double.parse(k["Amount"]);
          else
            balance -= double.parse(k["Amount"]);
          print(balance);
        }
      }
    }
    // return transactions.length;
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
                      child: FutureBuilder(
                        future: readJson(), // retrieving the json data
                        builder: (context, data) {
                          if (data.hasError) {
                            //in case if error found
                            return Center(child: Text("${data.error}"));
                          } else if (data.hasData) {
                            if (transactions.length == 0)
                              transactions = data.data
                                  as List<dynamic>; // putting data into map
                            else
                              print("not updated");
                            balanceCalc();
                            return AnimatedOpacity(
                              opacity: _visible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1500),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
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
                                        text: balance
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
                            );
                          } else {
                            // show circular progress while data is getting fetched from json file
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
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
                        top: MediaQuery.of(context).size.height * 0.26,
                        // right: offset,
                      ),
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
                      child: AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // Pay icon - with some more time designing the splashshape could be more smooth
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => TopUpPage(topup: false));
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
                              // Top up icon
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => TopUpPage(topup: true));
                                  },
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
                    // Transaction
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1500),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder(
                                future: readJson(), // fetch json data -
                                // I'm aware it's inefficient to do this on both futures,
                                // but it seemed the easiest way to allow both widgets to
                                // wait for the data to be read before being drawn
                                builder: (context, data) {
                                  if (data.hasError) {
                                    //in case if error found
                                    return Center(child: Text("${data.error}"));
                                  } else if (data.hasData) {
                                    if (transactions.length == 0)
                                      transactions = data.data as List<dynamic>;
                                    else
                                      print("not updated");
                                    return ListView.builder(
                                      // building the variable list of transactions
                                      // this list is for each day of transactions
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      // scrollDirection: Axis.vertical,
                                      itemCount: transactions[0].length,
                                      itemBuilder:
                                          (BuildContext content, int index) {
                                        return TransactionDay(
                                            transactions[0]
                                                .keys
                                                .elementAt(index),
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

// a class for transaction row widget
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
                    widget.moneyIn == 1
                        ? Icons.add_circle
                        : Icons
                            .local_mall, // dependent on if money is coming in or out
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
                    ? "+${widget.amount.toInt()}" // these have been converted to int to truncate the decimal so the formatting is correct
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
                    text: widget.amount.toStringAsFixed(2).split('.')[
                        1], // this is to convert the decimal numbers into a readable format
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

// the transaction class for each day
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
    String t = widget.tdate;
    if (widget.tdate == "04 October") {
      // This could be made variable by comparing it to todays date, but with the format of the data, this was easiest for now
      t = "TODAY";
    } else if (widget.tdate == "03 October") {
      t = "YESTERDAY";
    }
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
              t,
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
                  double.parse(transactions[0]["${widget.tdate}"][index]
                      ["Amount"]), // amount in transaction
                  transactions[0]["${widget.tdate}"][index][
                      "Name"], // name of who the transaction is being sent to/received from
                  int.parse(transactions[0]["${widget.tdate}"][index]
                      ["InOut"])); // whether is being received or sent
            },
          ),
        ],
      ),
    );
  }
}
