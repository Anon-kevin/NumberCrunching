import 'package:flutter/material.dart';

final variableController = TextEditingController();
final constraintController = TextEditingController();
final matrixA = [];
final matrixB = [];
final matrixC = [];

class SimplexController {
  //TODO: Use this to call SimplexSolver's method
  SimplexSolver simplexSolver = null;

  int numVar;
  int numCon;

  void createSimplexSolver() {
    simplexSolver = new SimplexSolver(numVar, numCon);
  }

  void addEditingController() {
    if (matrixA.length == 0) {
      for (int i = 0; i < 10; i++) {
        final smallA = [];
        for (int i = 0; i < 5; i++) {
          smallA.add(TextEditingController());
        }
        matrixA.add(smallA);
      }
    }
    if (matrixB.length == 0) {
      for (int i = 0; i < 10; i++) {
        matrixB.add(TextEditingController());
      }
    }
    if (matrixC.length == 0) {
      for (int i = 0; i < 5; i++) {
        matrixC.add(TextEditingController());
      }
    }
  }

  void setNum() {
    numVar = int.parse(variableController.text);
    numCon = int.parse(constraintController.text);
  }

  String printEquation() {
    if (simplexSolver != null)
      return simplexSolver.printEquation();
    else
      return null;
  }

  String printCondition() {
    if (simplexSolver != null)
      return simplexSolver.printCondition();
    else
      return null;
  }

  String printResult() {
    if (simplexSolver != null)
      return simplexSolver.printResult();
    else
      return null;
  }

  String printHintFirst() {
    if (simplexSolver != null)
      return simplexSolver.printHintFirst();
    else
      return null;
  }
  String printHintSecond() {
    if (simplexSolver != null)
      return simplexSolver.printHintSecond();
    else
      return null;
  }

  DataTable printTableu() {
    if (simplexSolver != null)
      return simplexSolver.printTableu();
    else
      return null;
  }

  DataTable printTableuFinal() {
    if (simplexSolver != null)
      return simplexSolver.printTableuFinal();
    else
      return null;
  }

  void calculateResult() {
    if (simplexSolver != null) simplexSolver.calculateSimplex();
  }

  void dispose() {
    variableController.dispose();
    constraintController.dispose();
    for (int i = 0; i < matrixA.length; i++) {
      for (int j = 0; j < matrixA[i].length; j++) {
        matrixA[i][j].dispose();
      }
    }
    for (int i = 0; i < matrixB.length; i++) {
      matrixB[i].dispose();
    }
    for (int i = 0; i < matrixC.length; i++) {
      matrixC[i].dispose();
    }
  }
}

class SimplexSolver {
  int rows;
  int cols;
  List<List<double>> A; //stores coefficients of all the variables
  List<double> B; //stores constants of constraints
  List<double> C; //stores the coefficients of the objective function
  List<double> R; //store the result
  double maximum;
  bool isUnbounded;

  SimplexSolver(int numVar, int numCon) {
    maximum = 0;
    isUnbounded = false;
    rows = numCon;
    cols = numVar + numCon;
    A = [];
    B = [];
    C = [];
    R = [];
    for (int i = 0; i < rows; i++) {
      List<double> smallA = [];
      for (int j = 0; j < cols - rows; j++) {
        smallA.add(int.parse(matrixA[i][j].text).toDouble());
      }
      for (int k = 0; k < rows; k++) {
        if (i == k) {
          smallA.add(1.0);
        } else {
          smallA.add(0.0);
        }
      }
      A.add(smallA);
    }

    for (int i = 0; i < rows; i++) {
      B.add(int.parse(matrixB[i].text).toDouble());
    }

    for (int i = 0; i < cols - rows; i++) {
      C.add(-int.parse(matrixC[i].text).toDouble());
    }
    for (int i = cols - rows; i < cols; i++) {
      C.add(0.0);
    }
  }

  void createSimplexSolver() {}

  bool simplexAlgorithmCalculataion() {
    //check whether the table is optimal,if optimal no need to process further
    if (checkOptimality() == true) {
      return true;
    }
    //find the column which has the pivot.The least coefficient of the objective function(C array).
    int pivotColumn = findPivotColumn();
    if (isUnbounded == true) {
      print("Error unbounded");
      return true;
    }
    //find the row with the pivot value.The least value item's row in the B array
    int pivotRow = findPivotRow(pivotColumn);
    //form the next table according to the pivot value
    doPivotting(pivotRow, pivotColumn);
    return false;
  }

  bool checkOptimality() {
    //if the table has further negative constraints,then it is not optimal
    bool isOptimal = false;
    int positiveValueCount = 0;
    //check if the coefficients of the objective function are negative
    for (int i = 0; i < C.length; i++) {
      double value = C[i];
      if (value >= 0) {
        positiveValueCount++;
      }
    }
    //if all the constraints are positive now,the table is optimal
    if (positiveValueCount == C.length) {
      isOptimal = true;
      print("");
    }
    return isOptimal;
  }

  void doPivotting(int pivotRow, int pivotColumn) {
    double pivotValue = A[pivotRow][pivotColumn]; //gets the pivot value

    List<double> pivotRowVals = []; //the column with the pivot

    List<double> pivotColVals = []; //the row with the pivot

    List<double> rowNew = []; //the row after processing the pivot value

    maximum = maximum -
        (C[pivotColumn] *
            (B[pivotRow] / pivotValue)); //set the maximum step by step
    //get the row that has the pivot value
    for (int i = 0; i < cols; i++) {
      pivotRowVals.add(A[pivotRow][i]);
    }
    //get the column that has the pivot value
    for (int j = 0; j < rows; j++) {
      pivotColVals.add(A[j][pivotColumn]);
    }

    //set the row values that has the pivot value divided by the pivot value and put into new row
    for (int k = 0; k < cols; k++) {
      rowNew.add(pivotRowVals[k] / pivotValue);
    }

    B[pivotRow] = B[pivotRow] / pivotValue;

    //process the other coefficients in the A array by subtracting
    for (int m = 0; m < rows; m++) {
      //ignore the pivot row as we already calculated that
      if (m != pivotRow) {
        for (int p = 0; p < cols; p++) {
          double multiplyValue = pivotColVals[m];
          A[m][p] = A[m][p] - (multiplyValue * rowNew[p]);
          //C[p] = C[p] - (multiplyValue*C[pivotRow]);
          //B[i] = B[i] - (multiplyValue*B[pivotRow]);
        }
      }
    }

    //process the values of the B array
    for (int i = 0; i < B.length; i++) {
      if (i != pivotRow) {
        double multiplyValue = pivotColVals[i];
        B[i] = B[i] - (multiplyValue * B[pivotRow]);
      }
    }
    //the least coefficient of the constraints of the objective function
    double multiplyValue = C[pivotColumn];
    //process the C array
    for (int i = 0; i < C.length; i++) {
      C[i] = C[i] - (multiplyValue * rowNew[i]);
    }

    //replacing the pivot row in the new calculated A array
    for (int i = 0; i < cols; i++) {
      A[pivotRow][i] = rowNew[i];
    }
  }

  //print the current A array
  void printA() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        print(A[i][j]);
      }
    }
  }

  //find the least coefficients of constraints in the objective function's position
  int findPivotColumn() {
    int location = 0;
    double minm = C[0];
    for (int i = 1; i < C.length; i++) {
      if (C[i] < minm) {
        minm = C[i];
        location = i;
      }
    }
    return location;
  }

  //find the row with the pivot value.The least value item's row in the B array
  int findPivotRow(int pivotColumn) {
    List<double> positiveValues = [];
//    std::vector<float> result(rows,0);
    List<double> result = [];
//    for (int i = 0; i < rows; i++) {
//      result.add(0.0);
//    }
    //float result[rows];
    int negativeValueCount = 0;

    for (int i = 0; i < rows; i++) {
      if (A[i][pivotColumn] > 0) {
        positiveValues.add(A[i][pivotColumn]);
      } else {
        positiveValues.add(0.0);
        negativeValueCount += 1;
      }
    }
    //checking the unbound condition if all the values are negative ones
    if (negativeValueCount == rows) {
      isUnbounded = true;
    } else {
      for (int i = 0; i < rows; i++) {
        double value = positiveValues[i];
        if (value > 0) {
          result.add(B[i] / value);
        } else {
          result.add(0.0);
        }
      }
    }
    //find the minimum's location of the smallest item of the B array
    double minimum = double.maxFinite;
    int location = 0;
    for (int i = 0; i < result.length; i++) {
      if (result[i] > 0) {
        if (result[i] < minimum) {
          minimum = result[i];
          location = i;
        }
      }
    }

    return location;
  }

  void calculateSimplex() {
    bool end = false;
    while (!end) {
      bool result = simplexAlgorithmCalculataion();
      if (result == true) {
        end = true;
      }
    }
    print("Answers for the Constraints of variables");
    for (int i = 0; i < cols; i++) {
      R.add(0.0);
    }
    for (int i = 0; i < A.length; i++) {
      //every basic column has the values, get it form B array
      int count0 = 0;
      int index = 0;
      for (int j = 0; j < rows; j++) {
        if (A[j][i] == 0.0) {
          count0 += 1;
        } else if (A[j][i] == 1) {
          index = j;
        }
      }

      if (count0 == rows - 1) {
        print(
            "variable ${index + 1} : ${B[index]} \n"); //every basic column has the values, get it form B array
        R[i] = B[index];
      } else {
        print("variable ${index + 1} : 0 \n");
        R[i] = 0;
      }
    }
    print("maximum value: $maximum \n "); //print the maximum values
    for (int i = 0; i < A.length; i++) {
      for (int j = 0; j < A[i].length; j++) {
        print(A[i][j]);
      }
    }
  }

  void printMatrix() {
    print("Matrix A");
    print(rows);
    print(cols);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        print(A[i][j]);
      }
    }

    for (int i = 0; i < matrixB.length; i++) {
      print(B[i]);
    }

    for (int i = 0; i < cols; i++) {
      print(C[i]);
    }

    calculateSimplex();
    print(maximum);
  }

  String printEquation() {
    String temp = "Y = ";
    for (int i = 0; i < cols - rows; i++) {
      temp += matrixC[i].text + "X${i + 1}";
      if (i + 1 != cols - rows) temp += " + ";
    }
    return temp;
  }

  String printCondition() {
    String temp = "";
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols - rows; j++) {
        temp += matrixA[i][j].text + "X${j + 1}";
        if (j + 1 != cols - rows) temp += " + ";
      }
      temp += " <= " + matrixB[i].text;
      if (i + 1 != rows) temp += "\n";
    }
    return temp;
  }

  String printResult() {
    String temp = "Y = ${maximum.toStringAsFixed(3)} \n(";
    for (int i = 0; i < cols - rows; i++) {
      temp += "X${i + 1}";
      if (i + 1 != cols - rows) temp += " , ";
    }
    temp += ") = (";
    for (int i = 0; i < cols - rows; i++) {
      temp += R[i].toStringAsFixed(3);
      if (i + 1 != cols - rows) temp += " , ";
    }
    temp += ")";
    return temp;
  }

  String printHintFirst() {
    String temp =
        "Step 1 : The problem is converted to canonical form by adding slack, surplus and artificial variables as appropiate.\n\n"
        "Since our problem contains only smaller and equal sign in the equality, add each constraint to slack variables (";
    for (int i = 0; i < rows; i++) {
      temp += "S${i + 1}";
      if (i + 1 != rows) {
        temp += " , ";
      }
    }
    temp += ")\n\nWe will have\n";
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols - rows; j++) {
        temp += matrixA[i][j].text + "X${j + 1} + ";
        if (j + 1 == cols - rows) {
          temp += "S${i + 1} ";
        }
      }
      temp += " = " + matrixB[i].text + "\n";
    }
    temp += "and ";
    for (int i = 0; i < cols - rows; i++) {
      temp += "X${i + 1}";
      if (i + 1 != cols - rows) {
        temp += " , ";
      }
    }
    temp += " , ";
    for (int i = 0; i < rows; i++) {
      temp += "S${i + 1}";
      if (i + 1 != rows) {
        temp += " , ";
      }
    }
    temp += " >= 0";
    temp += "\n\nStep 2 : Setting up the Tableu\n";
    return temp;
  }

  String printHintSecond(){
    String temp = "\nStep 3 : Check optimization\n";
    temp += "To check optimality using the tableau, all values in the last row must contain values greater than or equal to zero." +
        "If a value is less than zero, it means that variable has not reached its optimal value." +
        "As seen in the previous tableau, there are negative value(s) exists in the bottom row indicating that this solution is not optimal.\n\n";
    temp += "\nStep 4 : Identify Pivot Column\n";
    temp += "Find the smallest negative in the last row, the column related to that number will be the pivot column.\n";
    temp += "\nStep 5 : Identify Pivot Variable\n";
    temp += "Find the smallest indicator by dividing number in B column to number in pivot column, then we find the pivot row. The pivot variable is in either the pivot row and the pivot column.\n";
    temp += "\nStep 6: Create New Tableau\n";
    temp += "Using row operation to make the pivot variable to 1 and all other variable in the pivot column becomes 0.\n";
    temp += "\nStep 7: Check optimization (step 3)\n";
    temp += "Recheck the optimization, if it is optimized, we finish. Otherwise return to step 4.\n";
    temp += "The final tableu is defined as below\n";
    return temp;
  }

  DataTable printTableu() {
    List<DataColumn> dataColumn = [];
    List<DataRow> dataRow = [];
    for (int i = 0; i < cols - rows; i++) {
      dataColumn.add(DataColumn(
          label: Text("X${i + 1}")
      ));
    }
    for(int i = 0; i < rows; i++){
      dataColumn.add(DataColumn(
          label: Text("S${i + 1}")
      ));
    }
    dataColumn.add(DataColumn(
        label: Text("B")
    ));
    for(int i = 0; i < rows; i++){
      List<DataCell> dataCell = [];
      for(int j = 0; j < cols; j++){
        if(j < cols - rows) dataCell.add(DataCell(Text(matrixA[i][j].text)));
        else if(j - i == cols - rows) dataCell.add(DataCell(Text("1")));
        else dataCell.add(DataCell(Text("0")));
      }
      dataCell.add(DataCell(Text(B[i].toStringAsFixed(3))));
      dataRow.add(DataRow(cells: dataCell));
    }
    List<DataCell> dataCell = [];
    for(int i = 0; i < cols - rows; i++){
      dataCell.add(DataCell(Text("-" + matrixC[i].text, style: TextStyle(color: Colors.red))));
    }
    for(int i = 0; i < rows + 1; i++){
      dataCell.add(DataCell(Text("0", style: TextStyle(color: Colors.red))));
    }
    dataRow.add(DataRow(cells: dataCell));
    return DataTable(
      columns: dataColumn,
      rows: dataRow,
    );
  }

  DataTable printTableuFinal() {
    List<DataColumn> dataColumn = [];
    List<DataRow> dataRow = [];
    for (int i = 0; i < cols - rows; i++) {
      dataColumn.add(DataColumn(
          label: Text("X${i + 1}")
      ));
    }
    for(int i = 0; i < rows; i++){
      dataColumn.add(DataColumn(
          label: Text("S${i + 1}")
      ));
    }
    dataColumn.add(DataColumn(
        label: Text("B")
    ));
    for(int i = 0; i < rows; i++){
      List<DataCell> dataCell = [];
      for(int j = 0; j < cols; j++){
       dataCell.add(DataCell(Text(A[i][j].toStringAsFixed(3))));
      }
      dataCell.add(DataCell(Text(B[i].toStringAsFixed(3))));
      dataRow.add(DataRow(cells: dataCell));
    }
    List<DataCell> dataCell = [];
    for(int i = 0; i < cols; i++){
      dataCell.add(DataCell(Text(C[i].toStringAsFixed(3), style: TextStyle(color: Colors.red))));
    }
    dataCell.add(DataCell(Text(maximum.toStringAsFixed(3), style: TextStyle(color: Colors.red))));
    dataRow.add(DataRow(cells: dataCell));
    return DataTable(
      columns: dataColumn,
      rows: dataRow,
    );
  }
}
