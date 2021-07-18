import 'package:flutter/material.dart';
import 'package:calorie_needs_calculator/text_with_style.dart';

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

enum SingingCharacter { faible, modere, forte }

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
  String? submitted;
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

    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            backgroundColor: setColor(),
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextWithStyle(
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
                                TextWithStyle('Femme', color: Colors.pink),
                                new Switch(
                                    inactiveTrackColor: Colors.pink,
                                    activeTrackColor: Colors.blue,
                                    value: gender,
                                    onChanged: (bool b) {
                                      setState(() {
                                        gender = b;
                                      });
                                    }
                                ),
                                TextWithStyle('Homme', color: Colors.blue),
                              ],
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(15.0),
                            child: new TextButton(
                              onPressed: selectDateOfBirth,
                              child: TextWithStyle(
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
                            child: TextWithStyle(
                                "Votre taille est de : ${sliderHeight
                                    .toInt()} cm",
                                color: setColor()
                            ),
                          ),
                        new Slider(
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
                        ),
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
                          child: TextWithStyle(
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
                          child: TextWithStyle("Calculer", color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                          )
                      ),
                    ),
                  ],
              )
          )
      )
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

  Future<Null> dialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return Padding(
              padding: EdgeInsets.all(15.0),
              child: SimpleDialog(
                title: TextWithStyle(
                  "Votre besoin en calories",
                  color: setColor()
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                      child: TextWithStyle("Votre besoin de base est de : $calorieBase")
                  ),
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: TextWithStyle("Votre besoin avec une acitvitée est de : $calorieActivity")
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new ElevatedButton(
                        onPressed: () => {
                          Navigator.pop(buildContext)
                        },
                        child: TextWithStyle(
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
          return AlertDialog(
            title: TextWithStyle("Erreur"),
            content: TextWithStyle("Tous les champs ne sont pas remplis"),
            actions: <Widget>[
              new ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(buildContext)
                  },
                  child: TextWithStyle("OK", color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  )
              )
            ],
          );
        }
    );
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
          TextWithStyle(
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

  Color setColor() {
    if (gender) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
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
}
