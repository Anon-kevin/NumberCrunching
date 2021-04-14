import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final elementController = TextEditingController();
final listElementController = [
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
];

class SortingController {
  int type;
  MergeSortSolver mergeSortSolver = null;
  QuickSortSolver quickSortSolver = null;
  SortingController(int type) {
    this.type = type;
    if(type == 1){
      quickSortSolver = new QuickSortSolver();
    }
    else if(type == 2){
      mergeSortSolver = new MergeSortSolver();
    }
  }
  String printBefore(){
    if(type == 1){
      return quickSortSolver.printBefore();
    }
    else if(type == 2){
      return mergeSortSolver.printBefore();
    }
    else return "NO RESULT";
  }
  String printAfter(){
    if(type == 1){
      return quickSortSolver.printAfter();
    }
    else if(type == 2){
      return mergeSortSolver.printAfter();
    }
    else return "NO RESULT";
  }
  String printHint(){
    if(type == 1){
      return quickSortSolver.printHint();
    }
    else if(type == 2){
      return mergeSortSolver.printHint();
    }
    else return "NO HINT";
  }
  String printStepCount(){
    if(type == 1){
      return quickSortSolver.printStepCount();
    }
    else if(type == 2){
      return mergeSortSolver.printStepCount();
    }
    else return "0";
  }
  void calculateSort(){
    if(type == 1){
      quickSortSolver.quickSort();
    }
    else if(type == 2){
      mergeSortSolver.mergeSort();
    }
  }
}

class SortSolver {
  List<int> arr;
  int numElement;
  int stepCount = 0;
  String hint = "";
  SortSolver(){
    arr = [];
    numElement = int.parse(elementController.text);
    print(numElement);
    for (int i = 0; i < numElement; i++) {
      arr.add(int.parse(listElementController[i].text));
    }
  }

  String printHint(){
    return hint;
  }

  String printStepCount(){
    return stepCount.toString();
  }

  String printBefore(){
    String temp = "(";
    for(int i = 0; i < numElement; i++){
      temp += listElementController[i].text;
      if(i + 1 != numElement){
        temp += " , ";
      }
    }
    temp += ")";
    return temp;
  }

  String printAfter(){
    String temp = "(";
    for(int i = 0; i < numElement; i++){
      temp += arr[i].toString();
      if(i + 1 != numElement){
        temp += " , ";
      }
    }
    temp += ")";
    return temp;
  }
}

class MergeSortSolver extends SortSolver{
  void mergeSort() {
    hint += "Initial array : " + printBefore() + "\n";
    sort(0, arr.length - 1);
  }

  void merge(int l, int m, int r) {
    // Find sizes of two subarrays to be merged
    int n1 = m - l + 1;
    int n2 = r - m;

    /* Create temp arrays */
    List<int> L = [];
    List<int> R = [];

    /*Copy data to temp arrays*/
    for (int i = 0; i < n1; ++i) L.add(arr[l + i]);
    for (int j = 0; j < n2; ++j) R.add(arr[m + 1 + j]);

    /* Merge the temp arrays */

    // Initial indexes of first and second subarrays
    int i = 0, j = 0;

    // Initial index of merged subarry array
    int k = l;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        arr[k] = L[i];
        i++;
      } else {
        arr[k] = R[j];
        j++;
      }
      k++;
    }

    /* Copy remaining elements of L[] if any */
    while (i < n1) {
      arr[k] = L[i];
      i++;
      k++;
    }

    /* Copy remaining elements of R[] if any */
    while (j < n2) {
      arr[k] = R[j];
      j++;
      k++;
    }

    hint += "\n(";
    for(int i = 0; i < numElement; i++){
      hint += arr[i].toString();
      if(i+1 != numElement){
        hint += " , ";
      }
    }
    hint += ")\n";
  }

  // Main function that sorts arr[l..r] using
  // merge()
  void sort(int l, int r) {
    if (l < r) {
      // Find the middle point
      int m = (l + r) ~/ 2;
      hint += "In sort ($l, $r){\n";
      stepCount++;
      // Sort first and second halves
      sort(l, m);
      sort(m + 1, r);
      // Merge the sorted halves
      merge(l, m, r);
      hint += "} finished sort ($l, $r)\n";
    }
  }
}

class QuickSortSolver extends SortSolver {
  int partition(int low, int high) {
    int pivot = arr[high];
    int i = (low - 1); // index of smaller element
    for (int j = low; j < high; j++) {
      // If current element is smaller than the pivot
      if (arr[j] < pivot) {
        i++;

        // swap arr[i] and arr[j]
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    // swap arr[i+1] and arr[high] (or pivot)
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
  }

  /* The main function that implements QuickSort()
      arr[] --> Array to be sorted,
      low  --> Starting index,
      high  --> Ending index */
  void sort(int low, int high) {
    if (low < high) {
      /* pi is partitioning index, arr[pi] is
              now at right place */
      hint += "In sort ($low, $high){\n";
      stepCount++;
      int pi = partition(low, high);
      hint += "   Choose ${arr[pi]} as the partitioning value\n";
      // Recursively sort elements before
      // partition and after partition
      hint += "   Sort before ${arr[pi]}\n";
      sort(low, pi - 1);
      hint += "   " + printAfter() + "\n";
      hint += "   Sort after ${arr[pi]}\n";
      sort(pi + 1, high);
      hint += "   " + printAfter() + "\n";
      hint += "} finished ($low, $high)\n";
    }
  }

  void quickSort(){
    hint += "Initial array : " + printBefore() + "\n";
    sort(0, arr.length - 1);
  }
}
