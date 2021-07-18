import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Needs Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Calorie Needs Calculator',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool gender = false;
  double? age;
  double sliderHeight = 170.0;
  double? weightChanged;
  Object? sportSelection;
  int? calorieBase;
  int? calorieActivity;

  Map activities = {
    0: 'Faible',
    1: 'Modere',
    2: 'Forte'
  };

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      print("Nous sommes sur IOS");
    } else {
      print("Nous sommes sur Android");
    }
    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: (Platform.isIOS) ? new CupertinoPageScaffold(
        navigationBar: new CupertinoNavigationBar(
          backgroundColor: setColor(),
          middle: textWithStyle(widget.title),
        ),
          child: body()
      )
      : new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            backgroundColor: setColor(),
          ),
          body: body()
      )
    );
  }

  Widget body() {
    return new SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Padding(
              padding: EdgeInsets.all(20.0),
              child: textWithStyle(
                  'Remplissez tous les champs pour obtenir votre besoin journalier en calories',
                  fontSize: 17.0
              ),
            ),
            new Card(
              elevation: 10.0,
              child: new Column(
                children: [
                  new Padding(
                    padding: EdgeInsets.all(15.0),
                    child : new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textWithStyle('Femme', color: Colors.pink),
                        switchInTermsOfPlatform(),
                        textWithStyle('Homme', color: Colors.blue),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new TextButton(
                      onPressed: selectDateOfBirth,
                      child: textWithStyle(
                          (age == null)
                              ? "Appuyer pour entrer votre âge"
                              : "Votre age est de : ${age!.toInt()}",
                          color: Colors.white
                      ),
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(15.0),
                    child: textWithStyle(
                        "Votre taille est de : ${sliderHeight
                            .toInt()} cm",
                        color: setColor()
                    ),
                  ),
                  sliderInTermsOfPlatform(),
                  new Padding(
                    padding: EdgeInsets.all(15.0),
                    child : new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string) {
                        setState(() {
                          weightChanged = double.tryParse(string);
                        });
                      },
                      decoration: new InputDecoration(
                          labelText: 'Entrer votre poids en kilos'
                      ),
                    ),
                  ),
                  new Padding(
                      padding: EdgeInsets.all(15.0),
                      child: textWithStyle(
                          "Quelle est votre activité sportive ?",
                          color: setColor()
                      )
                  ),
                  new Padding(
                      padding: EdgeInsets.all(15.0),
                      child : rowRadio()
                  )
                ],
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
              child: new ElevatedButton(
                  onPressed: calculateNeedsCalories,
                  child: textWithStyle("Calculer", color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                  )
              ),
            ),
          ],
        )
    );
  }

  Widget sliderInTermsOfPlatform() {
    if (Platform.isIOS) {
      return new CupertinoSlider(
          value: sliderHeight,
          min: 100,
          max: 220.0,
          activeColor: setColor(),
          divisions: 25,
          onChanged: (double d) {
            setState(() {
              sliderHeight = d;
            });
          }
      );
    } else {
      return new Slider(
          value: sliderHeight,
          min: 100,
          max: 220.0,
          activeColor: setColor(),
          divisions: 25,
          onChanged: (double d) {
            setState(() {
              sliderHeight = d;
            });
          }
      );
    }
  }

  Widget switchInTermsOfPlatform() {
    if (Platform.isIOS) {
      return new CupertinoSwitch(
          value: gender,
          activeColor: Colors.blue,
          onChanged: (bool b) {
            setState(() {
              gender = b;
            });
          }
      );
    } else {
      return new Switch(
          inactiveTrackColor: Colors.pink,
          activeTrackColor: Colors.blue,
          value: gender,
          onChanged: (bool b) {
            setState(() {
              gender = b;
            });
          }
      );
    }
  }

  Widget textWithStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    if (Platform.isIOS) {
      return new DefaultTextStyle(
          style: new TextStyle(
              color: color,
              fontSize: fontSize
          ),
          child: new Text(
            data,
            textAlign: TextAlign.center,
          )
      );
    } else {
      return Text(
          data,
          textAlign: TextAlign.center,
          style: new TextStyle(
              color: color,
              fontSize: fontSize
          )
      );
    }
  }

  Row rowRadio() {
    List<Widget> l = [];
    activities.forEach((key, value) {
      Column column = new Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: [
          new Radio<Object>(
              activeColor: setColor(),
              value: key,
              groupValue: sportSelection,
              onChanged: (Object? i) {
                setState(() {
                  sportSelection = i;
                });
              }
          ),
          textWithStyle(
              value,
              color: setColor()
          )
        ],
      );
      l.add(column);
    });
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: l
    );
  }

  Future<Null> selectDateOfBirth() async {
    DateTime? choice = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now()
    );
    if (choice != null) {
      setState(() {
        var diff = new DateTime.now().difference(choice);
        var days = diff.inDays;
        var years = (days / 365);
        setState(() {
          age = years;
        });
      });
    }
  }

  Future<Null> dialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return Padding(
              padding: EdgeInsets.all(15.0),
              child: SimpleDialog(
                title: textWithStyle(
                  "Votre besoin en calories",
                  color: setColor()
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                      child: textWithStyle("Votre besoin de base est de : $calorieBase")
                  ),
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: textWithStyle("Votre besoin avec une acitvitée est de : $calorieActivity")
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new ElevatedButton(
                        onPressed: () => {
                          Navigator.pop(buildContext)
                        },
                        child: textWithStyle(
                            "OK",
                            color: Colors.white
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                        )
                    )
                  )
                ],
              )
          );
        }
    );
  }
  
  Future<Null> alert() async {
    return showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: textWithStyle("Erreur"),
              content: textWithStyle("Tous les champs ne sont pas remplis"),
              actions: <Widget>[
                new CupertinoButton(
                    onPressed: () => {
                      Navigator.pop(buildContext)
                    },
                    child: textWithStyle("OK", color: Colors.red),
                    color: Colors.white
                )
              ],
            );
          } else {
            return AlertDialog(
              title: textWithStyle("Erreur"),
              content: textWithStyle("Tous les champs ne sont pas remplis"),
              actions: <Widget>[
                new ElevatedButton(
                    onPressed: () => {
                      Navigator.pop(buildContext)
                    },
                    child: textWithStyle("OK", color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    )
                )
              ],
            );
          }
        }
    );
  }

  void calculateNeedsCalories() {
    if (age != null && weightChanged != null && sportSelection != null) {
      if (gender) {
        calorieBase = (66.4730 + (13.7516 * weightChanged!) + (5.0033 * sliderHeight) - (6.7550 * age!)).toInt();
      } else {
        calorieBase = (655.0955 + (9.5634 * weightChanged!) + (1.8496 * sliderHeight) - (4.6756 * age!)).toInt();
      }
      switch(sportSelection) {
        case 0:
          calorieActivity = (calorieBase! * 1.2).toInt();
          break;
        case 1:
          calorieActivity = (calorieBase! * 1.5).toInt();
          break;
        case 2:
          calorieActivity = (calorieBase! * 1.8).toInt();
          break;
        default:
          calorieActivity = calorieBase;
          break;
      }
      setState(() {
        dialog();
      });
    } else {
      alert();
    }
  }

  Color setColor() {
    if (gender) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }
}
