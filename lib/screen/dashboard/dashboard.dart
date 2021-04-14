import 'package:flutter/material.dart';
import '../drawer.dart';
import 'dart:math';

const double padding = 25;

Shader linearGradient = LinearGradient(
  colors: <Color>[Colors.blue, Colors.greenAccent],
).createShader(Rect.fromLTWH(0.0, 0.0, 120.0, 120.0));

class DataReader {
  TheOracle oracle = TheOracle();
  String defaultType = "All Time";
  List<double> allTime = [];
  List<double> lastYear = [];
  List<double> lastMonth = [];
  List<double> lastWeek = [];

  void updateScore() {
    this.allTime = [4.5, 8.5, 3.5, 9.6, 3.3, 10, 9, 8, 7, 8, 9];
    this.lastYear = [8.5, 3.5, 9.6, 3.3, 10];
    this.lastMonth = [3.5, 9.6, 3.3, 10];
    this.lastWeek = [9.6, 3.3, 10];
  }

  List<double> getScore() {
    updateScore();
    if (defaultType == "All Time") return allTime;
    if (defaultType == "Last Year") return lastYear;
    if (defaultType == "Last Month") return lastMonth;
    if (defaultType == "Last Week") return lastWeek;
  }

  List<double> getSpecificScore(String type) {
    updateScore();
    if (type == "All Time") return allTime;
    if (type == "Last Year") return lastYear;
    if (type == "Last Month") return lastMonth;
    if (type == "Last Week") return lastWeek;
  }

  double getAverage() {
    List<double> array = getScore();
    return getSpecificAverage(array);
  }

  double getSpecificAverage(List<double> data) {
    double total = 0;
    for (var i = 0; i < data.length; i++) {
      total += data[i];
    }
    return total / data.length;
  }

  void switchType() {
    if (defaultType == "All Time")
      defaultType = "Last Year";
    else if (defaultType == "Last Year")
      defaultType = "Last Month";
    else if (defaultType == "Last Month")
      defaultType = "Last Week";
    else if (defaultType == "Last Week") defaultType = "All Time";
  }

  double predict() {
    updateScore();
    return oracle.predict(allTime);
  }

  List<double> predictSeries() {
    return oracle.predictSeries(allTime);
  }
}

class TheOracle {
  List<double> trainedData = [];
  List<double> cubic = [];
  List<double> quartic = [];
  int bestModel = 4;

  double predict(List<double> data) {
    if (data != trainedData) train(data);
    return calculate(data, getBestModel());
  }

  List<double> predictSeries(List<double> data) {
    if (data != trainedData) train(data);

    List<double> result = [];
    double temp;
    double x;
    for (int i = 0; i < 30; i++) {
      for (int s = 0; s < 4; s++) {
        temp = 0;
        x = i + 0.25 * s;
        for (int j = 0; j < getBestModel().length; j++) {
          temp += getBestModel()[j] * pow(x + 1, j);
        }
        if (temp < 0) temp = 0;
        result.add(temp);
      }
    }

    double compress = 10 / result.reduce(max);
    for (int i = 0; i < result.length; i++) result[i] = result[i] * compress;

    return result;
  }

  List<double> regress(List<double> data, int degree) {
    //Polynomial Fit
    int pairs = data.length;
    List<double> x = List(pairs);
    List<double> y = List(pairs);
    for (int i = 0; i < pairs; i++) {
      x[i] = (i + 1).toDouble();
    }
    for (int i = 0; i < pairs; i++) {
      y[i] = data[i];
    }
    List<double> X = List(2 * degree +
        1); //Array that will store the values of sigma(xi),sigma(xi^2),sigma(xi^3)....sigma(xi^2n)
    for (int i = 0; i < 2 * degree + 1; i++) {
      X[i] = 0;
      for (int j = 0; j < pairs; j++)
        X[i] = X[i] +
            pow(x[j],
                i); //consecutive positions of the array will store N,sigma(xi),sigma(xi^2),sigma(xi^3)....sigma(xi^2n)
    }
    List<List<double>> B =
        List.generate(degree + 1, (i) => List(degree + 2), growable: false);
    List<double> a = List(degree +
        1); //B is the Normal matrix(augmented) that will store the equations, 'a' is for value of the final coefficients
    for (int i = 0; i < a.length; i++) a[i] = 0; // initialize a
    for (int i = 0; i <= degree; i++)
      for (int j = 0; j <= degree; j++)
        B[i][j] = X[i +
            j]; //Build the Normal matrix by storing the corresponding coefficients at the right positions except the last column of the matrix
    List<double> Y = List(degree +
        1); //Array to store the values of sigma(yi),sigma(xi*yi),sigma(xi^2*yi)...sigma(xi^n*yi)
    for (int i = 0; i < degree + 1; i++) {
      Y[i] = 0;
      for (int j = 0; j < pairs; j++)
        Y[i] = Y[i] +
            pow(x[j], i) *
                y[j]; //consecutive positions will store sigma(yi),sigma(xi*yi),sigma(xi^2*yi)...sigma(xi^n*yi)
    }
    for (int i = 0; i <= degree; i++)
      B[i][degree + 1] = Y[
          i]; //load the values of Y as the last column of B(Normal Matrix but augmented)
    degree = degree +
        1; //n is made n+1 because the Gaussian Elimination part below was for n equations, but here n is the degree of polynomial and for n degree we get n+1 equations
    for (int i = 0;
        i < degree;
        i++) //From now Gaussian Elimination starts(can be ignored) to solve the set of linear equations (Pivotisation)
      for (int k = i + 1; k < degree; k++)
        if (B[i][i] < B[k][i])
          for (int j = 0; j <= degree; j++) {
            double temp = B[i][j];
            B[i][j] = B[k][j];
            B[k][j] = temp;
          }

    for (int i = 0; i < degree - 1; i++) //loop to perform the gauss elimination
      for (int k = i + 1; k < degree; k++) {
        double t = B[k][i] / B[i][i];
        for (int j = 0; j <= degree; j++)
          B[k][j] = B[k][j] -
              t *
                  B[i][
                      j]; //make the elements below the pivot elements equal to zero or elimnate the variables
      }
    for (int i = degree - 1; i >= 0; i--) //back-substitution
    {
      //x is an array whose values correspond to the values of x,y,z..
      a[i] = B[i][
          degree]; //make the variable to be calculated equal to the rhs of the last equation
      for (int j = 0; j < degree; j++)
        if (j !=
            i) //then subtract all the lhs values except the coefficient of the variable whose value                                   is being calculated
          a[i] = a[i] - B[i][j] * a[j];
      a[i] = a[i] /
          B[i][
              i]; //now finally divide the rhs by the coefficient of the variable to be calculated
    }
    return a;
  }

  void train(List<double> data) {
    cubic = regress(data, 3);
    quartic = regress(data, 4);
    trainedData = data;

    double first = calculate(data, cubic);
    double second = calculate(data, quartic);
    if ((first - data[data.length - 1]).abs() >
        (second - data[data.length - 1]).abs())
      bestModel = 4;
    else
      bestModel = 3;
  }

  double calculate(List<double> data, List<double> model) {
    if (data != trainedData) train(data);

    double result = 0;
    for (int i = 0; i < model.length; i++)
      result += model[i] * pow(data.length + 1, i);
    if (result > 10) result = 10;
    if (result < 0) result = 0;
    return result;
  }

  List<double> getBestModel() {
    if (bestModel== 3)
      return cubic;
    else
      return quartic;
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
        ),
        drawer: DrawTab(),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(padding),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Image(
                image: AssetImage('assets/images/dashboard-art.png'),
              ),
            ),
            ScoreGraph(),
            PerformanceScore(),
            PerformanceHistory(),
            ScorePredictor()
          ],
        ));
  }
}

class PerformanceScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PerformanceScore();
  }
}

class _PerformanceScore extends State<PerformanceScore> {
  DataReader userData = DataReader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: padding),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Performance Score", style: TextStyle(fontSize: 20.0)),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      userData.getAverage().toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 140.0,
                          foreground: Paint()..shader = linearGradient),
                    )),
                Padding(
                    padding: EdgeInsets.all(6),
                    child: Text(
                      userData.defaultType,
                      style: TextStyle(
                          fontSize: 20.0,
                          foreground: Paint()..shader = linearGradient),
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      "You're doing great, but we think you can go further!",
                      style: TextStyle(fontSize: 16.0)),
                ),
              ]),
        ),
        onPressed: () {
          setState(() {
            userData.switchType();
          });
        },
      ),
    );
  }
}

class ScoreGraph extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScoreGraph();
  }
}

class _ScoreGraph extends State<ScoreGraph> {
  DataReader userData = DataReader();
  List<double> chartValues;

  @override
  List<double> createAverage() {
    List<double> result = [];
    for (var i = 0; i < chartValues.length - 1; i++) {
      result.add(chartValues[i]);
      result.add((chartValues[i] + chartValues[i + 1]) / 2);
    }
    result.add(chartValues[chartValues.length - 1]);
    return result;
  }

  void reDraw(List<double> data) {
    chartValues = data;
    for (var i = 0; i <= 3; i++) {
      chartValues = createAverage();
    }
  }

  void initState() {
    super.initState();
    reDraw(userData.getScore());
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: padding),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Score Analysis",
                        style: TextStyle(fontSize: 20.0)),
                  ),
                  SizedBox(
                    height: 350,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (var i = 0; i < chartValues.length; i++)
                          Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(0.5),
                                child: Column(children: <Widget>[
                                  Container(
                                    color: Color.fromRGBO(0, 0, 0, 0),
                                    width: 4,
                                    height: 300 - chartValues[i] * 30,
                                  ),
                                  Container(
                                    color: Color.fromRGBO(
                                        50,
                                        (chartValues[i] * 25).toInt(),
                                        255,
                                        i % 16 == 0 ? 1 : 0.2),
                                    width: 4,
                                    height: chartValues[i] * 30,
                                  ),
                                ])),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                  i % 16 == 0 ? chartValues[i].toString() : ""),
                            )
                          ])
                      ],
                    ),
                  ),
                  Text(
                    userData.defaultType,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ]),
          ),
          onPressed: () {
            setState(() {
              userData.switchType();
              reDraw(userData.getScore());
            });
          },
        ));
  }
}

class PerformanceHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PerformanceHistory();
  }
}

class _PerformanceHistory extends State<PerformanceHistory> {
  DataReader userData = DataReader();
  double currentScore = 0;
  double oldScore = 0;
  double difference = 0;

  void initState() {
    super.initState();
    calculate();
  }

  void calculate() {
    currentScore = userData.getAverage();
    List<double> oldData = userData.getScore();
    oldData.removeLast();
    oldScore = userData.getSpecificAverage(oldData);
    difference = currentScore / oldScore - 1;
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: padding),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Performance History",
                        style: TextStyle(fontSize: 20.0)),
                  ),
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            color: Color.fromRGBO(
                                50, (currentScore * 25).toInt(), 255, 1),
                            width: currentScore * 25,
                            height: 20,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            color: Color.fromRGBO(
                                50, (oldScore * 25).toInt(), 255, 1),
                            width: oldScore * 25,
                            height: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 26),
                        child: Row(children: <Widget>[
                          Text("You performed ",
                              style: TextStyle(fontSize: 16.0)),
                          Text((100 * difference).toInt().toString(),
                              style: TextStyle(fontSize: 19.0)),
                          Text(difference > 0 ? "% better" : "% worse",
                              style: TextStyle(fontSize: 16.0)),
                          Text(" than before", style: TextStyle(fontSize: 16.0))
                        ]),
                      ),
                    ],
                  ),
                ]),
          ),
          onPressed: () {
            print("Simplex");
          },
        ));
  }
}

class ScorePredictor extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScorePredictor();
  }
}

class _ScorePredictor extends State<ScorePredictor> {
  bool showFuture = false;
  bool showGraph = false;
  DataReader userData = DataReader();

  void changeState(){
    if (!showFuture) {
      showFuture = true;
    } else {
      showGraph = true;
    }
  }

  var entranceView = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("Time Travel", style: TextStyle(fontSize: 20.0)),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Hey there!", style: TextStyle(fontSize: 40.0)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18),
              child: Text("Want a sneak peak of the future?",
                  style: TextStyle(fontSize: 16.0)),
            )
          ],
        )
      ]);

  Widget build(BuildContext context) {
    var scoreView = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text("Time Travel", style: TextStyle(fontSize: 20.0)),
          ),
          Column(
            children: <Widget>[
              Text(
                userData.predict().toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 140.0,
                    foreground: Paint()..shader = linearGradient),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: Text("Don't let this affect your actual result",
                    style: TextStyle(fontSize: 16.0)),
              )
            ],
          )
        ]);

    var graphView = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text("Score Trend",
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
          ),
          SizedBox(
            height: 350,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var i = 0; i < userData.predictSeries().length; i++)
                  Column(children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        color: Color.fromRGBO(0, 0, 0, 0),
                        width: 4,
                        height: 300 - userData.predictSeries()[i] * 30,
                      ),
                      Container(
                        color: Color.fromRGBO(50,
                            (userData.predictSeries()[i] * 25).toInt(), 255, 1),
                        width: 4,
                        height: userData.predictSeries()[i] * 30,
                      ),
                    ]),
                  ])
              ],
            ),
          ),
        ]);

    return Container(
        padding: EdgeInsets.only(top: padding),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(children: <Widget>[
              showFuture ? scoreView : entranceView,
              showFuture && !showGraph
                  ? Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Tap to see your score trend",
                          style: TextStyle(color: Colors.blue)))
                  : Text(""),
              showGraph ? graphView : Text(""),
            ]),
          ),
          onPressed: () {
            setState(() {
              changeState();
            });
          },
        ));
  }
}
