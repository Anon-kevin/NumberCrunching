class Type {
  String _name;
  String _image;
  String _next;
  List<Solver> _solverList;

  Type({String name, String image, String next, List<Solver> solutionList}) {
    this._name = name;
    this._image = image;
    this._next = next;
    this._solverList = solutionList;
  }

  void setName(String n) {
    this._name = n;
  }

  void setImage(String i) {
    this._image = i;
  }

  void setNext(String n) {
    this._next = n;
  }

  String getName() {
    return this._name;
  }

  String getImage() {
    return this._image;
  }

  List<Solver> getTypeList() {
    return this._solverList;
  }

  String getNext() {
    return this._next;
  }
}

class Solver {
  String _name;
  String _description;
  String _image;
  String _next;

  Solver({String name, String description, String image, String next}) {
    this._name = name;
    this._description = description;
    this._image = image;
    this._next = next;
  }

  void setName(String n) {
    this._name = n;
  }

  void setDescription(String d) {
    this._description = d;
  }

  void setImage(String i) {
    this._image = i;
  }

  void setNext(String n) {
    this._next = n;
  }

  String getName() {
    return this._name;
  }

  String getDescription() {
    return this._description;
  }

  String getImage() {
    return this._image;
  }

  String getNext() {
    return this._next;
  }
}

//TODO: Define type
//TODO: Optimization declaration
Type optimization = Type(
  name: "Optimization",
  image: 'assets/images/optimization-icon.png',
  next: '/optimization',
  solutionList: [
    Solver(
      name: "Basic Simplex Method",
      description:
          "Using simplex method to solve problem with all positive input",
      image: "assets/images/iconSimplexMethod-06.png",
      next: '/solver/basic_simplex',
    ),
//    Type(
//        name: "Branch and Bound",
//        description: 'The "divide and conquer" method to solve LP with integer conditions',
//        image: "assets/images/iconBranchAndBound-06.png"
//    ),
//    Type(
//        name: "Cutting Plane",
//        description: "Refine a feasible set or objective function by means of linear inequalities",
//        image: "assets/images/iconCuttingPlane-06.png"
//    ),
  ],
);

Type sorting = Type(
  name: "Sorting",
  image: 'assets/images/sorting-icon.png',
  next: '/sorting',
  solutionList: [
    Solver(
      name: "Quick Sort",
      description:
          "Picks an element as pivot and partitions the given array around the picked pivot.",
      image: "assets/images/iconSimplexMethod-06.png",
      next: '/solver/quick',
    ),
    Solver(
      name: "Merge Sort",
      description:
          "Divides input array in two halves, calls itself for the two halves and then merges the two sorted halves",
      image: "assets/images/iconSimplexMethod-06.png",
      next: '/solver/merge',
    ),
  ],
);
