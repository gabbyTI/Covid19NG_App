import 'dart:async';
import 'dart:convert';
import 'package:covid19_nig/models/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MaterialApp(
        title: "COVID19 NG",
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  });
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String url = "https://covidnigeria.herokuapp.com/api";
  var totalConfirmedCases;
  var totalActiveCases;
  var discharged;
  var death;
  List<City> city;
  List<dynamic> states;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
  }

  Future getJsonData() async {
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept": "application/json"},
    );

    // print(response.body);

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      totalConfirmedCases = convertDataToJson['data']['totalConfirmedCases'];
      totalActiveCases = convertDataToJson['data']['totalActiveCases'];
      discharged = convertDataToJson['data']['discharged'];
      death = convertDataToJson['data']['death'];

      states = convertDataToJson['data']['states'];
    });
    print(states);
    city = states.map((state) => City.fromJson(state)).toList();
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Covid-19 Live Update Nigeria'),
        ),
        body: RefreshIndicator(
          onRefresh: getJsonData,
          child: SafeArea(
            child: city == null
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 330,
                            color: Colors.black87,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  height: 90,
                                  margin: EdgeInsets.only(top: 60),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                        'assets/images/nigeria_flag.png'),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(4),
                              ),
                              Text(
                                "COVID-19 CASES",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.all(4),
                              ),
                              Text(
                                "NIGERIA",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 77),
                                padding: EdgeInsets.all(10),
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              child: Text("Total",
                                                  style: TextStyle(
                                                      color: Colors.black54))),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: totalConfirmedCases != null
                                                ? Text(
                                                    totalConfirmedCases
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16))
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              child: Text("Active",
                                                  style: TextStyle(
                                                      color: Colors.black54))),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: totalActiveCases != null
                                                ? Text(
                                                    totalActiveCases.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16))
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 5),
                                              child: Text("Recovered",
                                                  style: TextStyle(
                                                      color: Colors.black54))),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: discharged != null
                                                ? Text(discharged.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16))
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 5),
                                              child: Text("Deaths",
                                                  style: TextStyle(
                                                      color: Colors.black54))),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: death != null
                                                ? Text(death.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16))
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              StateInfo()
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ));
  }

  StateInfo() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'State',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
            DataColumn(
              label: Text(
                'Total',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
            DataColumn(
              label: Text(
                'Active',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
            DataColumn(
              label: Text(
                'Recovered',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
            DataColumn(
              label: Text(
                'Deaths',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
          ],
          rows: city == null
              ? const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(CircularProgressIndicator()),
                      DataCell(CircularProgressIndicator()),
                      DataCell(CircularProgressIndicator()),
                      DataCell(CircularProgressIndicator()),
                      DataCell(CircularProgressIndicator()),
                    ],
                  ),
                ]
              : city
                  .map(
                    (state) => DataRow(
                      cells: [
                        DataCell(
                          Text(state.name),
                        ),
                        DataCell(
                          Text(state.confirmedCases),
                        ),
                        DataCell(
                          Text(state.casesOnAdmission),
                        ),
                        DataCell(
                          Text(state.discharged),
                        ),
                        DataCell(
                          Text(state.death),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
