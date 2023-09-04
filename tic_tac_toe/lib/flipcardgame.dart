// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';

enum Level { Hard, Medium, Easy }

class FlipCardGame extends StatefulWidget {
  final Level level;
  FlipCardGame(this.level);
  @override
  _FlipCardGameState createState() => _FlipCardGameState(level);
}

class _FlipCardGameState extends State<FlipCardGame> {
  _FlipCardGameState(this._level);
  late int _previousIndex = -1;
  late bool _flip = false;
  late bool _start = false;

  late bool _wait = false;
  late Level _level;
  late Timer _timer;
  late int _time = 5;
  late int _left;
  late bool _isFinished;
  late List<String> _data;

  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  bool get isMounted => mounted;

  Widget getItem(int index) {
    print(_data[index]);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.lightBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 0.5,
              spreadRadius: 0.4,
              offset: Offset(2.0, 1),
            )
          ]),
      margin: EdgeInsets.all(4.0),
      child: Image.asset(_data[index]),
    );
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (isMounted) {
        setState(() {
          _time -= 1;
        });
      }
    });
  }

  restartGame() {
    startTimer();
    _data = getSource(_level);
    _cardFlips = getCardState(_level);
    _cardStateKeys = getCardKeys(_level);
    _time = 5;
    _left = _data.length ~/ 2;

    _isFinished = false;
    Future.delayed(Duration(seconds: 6), () {
      if (isMounted) {
        setState(() {
          _start = true;
          _timer.cancel();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    restartGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isFinished
        ? Scaffold(
            body: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  restartGame();
                });
              },
              child: Container(
                height: 50,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Replay",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: GoogleFonts.gluten().fontFamily,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ))
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(4.0),
                          child: _time > 0
                              ? Text("$_time remaining")
                              : Text("$_left cards left")),
                      Padding(
                          padding: EdgeInsets.all(4.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => _start
                                ? FlipCard(
                                    key: _cardStateKeys[index],
                                    onFlip: () {
                                      if (!_flip) {
                                        _flip = true;
                                        _previousIndex = index;
                                      } else {
                                        _flip = false;
                                      }
                                      if (_previousIndex != index) {
                                        if (_data[index] ==
                                            _data[_previousIndex]) {
                                          _cardFlips[_previousIndex] = false;
                                          _cardFlips[index] = false;
                                          if (isMounted) {
                                            setState(() {
                                              _left -= 1;
                                            });
                                          }
                                          print(_cardFlips);
                                          if (_cardFlips.every(
                                              (element) => element == false)) {
                                            setState(() {
                                              Future.delayed(
                                                  Duration(seconds: 1), (() {
                                                _isFinished = true;
                                                _start = false;
                                              }));
                                            });
                                          }
                                        } else {
                                          _wait = true;
                                          Future.delayed(
                                              Duration(milliseconds: 1500), () {
                                            _cardStateKeys[_previousIndex]
                                                .currentState!
                                                .toggleCard();
                                            _previousIndex = index;
                                            _cardStateKeys[_previousIndex]
                                                .currentState!
                                                .toggleCard();
                                          });
                                          Future.delayed(
                                              Duration(milliseconds: 250), () {
                                            setState(() {
                                              _wait = false;
                                            });
                                          });
                                        }
                                      }
                                      setState(() {});
                                    },
                                    flipOnTouch:
                                        _wait ? false : _cardFlips[index],
                                    direction: FlipDirection.HORIZONTAL,
                                    front: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 3,
                                              spreadRadius: 0.8,
                                              offset: Offset(2.0, 1),
                                            )
                                          ]),
                                      margin: EdgeInsets.all(4.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/background.jpg",
                                        ),
                                      ),
                                    ),
                                    back: getItem(index))
                                : getItem(index),
                            itemCount: _data.length,
                          ))
                    ],
                  )),
            ),
          );
  }
}
