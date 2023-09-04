import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flipcardgame.dart';

class MemoryHomePage extends StatefulWidget {
  @override
  State<MemoryHomePage> createState() => _MemoryHomePageState();
}

class _MemoryHomePageState extends State<MemoryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _list[index].primarycolor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                spreadRadius: 0.5,
                                offset: Offset(3, 4))
                          ],
                        ),
                      ),
                      Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _list[index].secondarycolor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 0.4,
                                color: Colors.black12,
                                offset: Offset(5, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print(_list[index].goto);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => _list[index].goto));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                child: Text(
                                  _list[index].name,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 17, 30),
                                      fontSize: 30,
                                      fontFamily:
                                          GoogleFonts.gluten().fontFamily,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: genratestar(_list[index].noOfstar),
                              )
                            ],
                          )),
                    ]),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

List<Widget> genratestar(int no) {
  List<Widget> _icons = [];
  for (int i = 0; i < no; i++) {
    _icons.insert(
        i,
        Icon(
          Icons.star,
          color: Colors.yellow,
        ));
  }
  return _icons;
}

class Details {
  String name;
  Color primarycolor;
  Color secondarycolor;
  int noOfstar;
  Widget goto;

  Details({
    required this.name,
    required this.primarycolor,
    required this.secondarycolor,
    required this.noOfstar,
    required this.goto,
  });
}

List<Details> _list = [
  Details(
    name: "EASY",
    primarycolor: Colors.green,
    secondarycolor: Colors.green[300]!,
    noOfstar: 1,
    goto: FlipCardGame(Level.Easy),
  ),
  Details(
    name: "MEDIUM",
    primarycolor: Colors.orange,
    secondarycolor: Colors.orange[300]!,
    noOfstar: 2,
    goto: FlipCardGame(Level.Medium),
  ),
  Details(
    name: "HARD",
    primarycolor: Colors.red,
    secondarycolor: Colors.red[300]!,
    noOfstar: 3,
    goto: FlipCardGame(Level.Hard),
  )
];
