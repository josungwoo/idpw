import 'package:flutter/material.dart';
import 'package:idpw/datasets.dart';
import 'package:idpw/datasave.dart'; // 여기에 SP생성하는 클래스 있습니다

void main() {
  runApp(const MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Datasets> dataSetss = []; // 데이터를 저장할 리스트 생성
  bool _isObscure = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  static const idpwStyle = TextStyle(
    fontSize: 15,
    color: Colors.black,
  );
  static const nameStyle =
      TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);

  //앱 실행시 최초로 prefs를 가장 먼저 초기화 해줘야함

  @override
  void initState() {
    super.initState();
    SpDatasave().init().then((value) => updatescreen());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("idpw"),
          //TODO: for Debugning about print Items
          actions: [
            TextButton(
                onPressed: () {
                  //TODO: 데이터 읽어보는 기능 추가
                  readDatas();
                  setState(() {});
                },
                child:
                    const Icon(Icons.slideshow_outlined, color: Colors.white)),
            TextButton(
                onPressed: () {
                  //TODO: 데이터 삭제하는 데이터 추가
                  setState(() {});
                },
                child: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
        body: ListView(
          children: showLists(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showalert();
            }),
      ),
    );
  }

  //데이터 입력용 다이얼로그를 띄워줌
  void showalert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Plus"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: "ID",
                      ),
                    ),
                    TextField(
                      controller: _pwController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          labelText: "PW",
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                print(_isObscure);
                                _isObscure = !_isObscure;
                              });
                            },
                          )),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 12, color: Colors.lightBlue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _nameController.text = '';
                      _idController.text = '';
                      _pwController.text = '';
                    },
                  ),
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      //TODO: 데이터 저장하는 곳
                      setState(() {
                        saveData();
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
        });
  }

  //데이터 수정용 다이얼로그 구현
  void showEditAlert(element) {
    _nameController.text = element.name;
    _idController.text = element.id;
    _pwController.text = element.pw;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Edit"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                    // TextField(
                    //   controller: _nameController,
                    //   autofillHints: [element.name],
                    //   decoration: const InputDecoration(
                    //     labelText: "Name",
                    //   ),
                    // ),
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: "ID",
                      ),
                    ),
                    TextField(
                      controller: _pwController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          labelText: "PW",
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                print(_isObscure);
                                _isObscure = !_isObscure;
                              });
                            },
                          )),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 12, color: Colors.lightBlue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _nameController.text = '';
                      _idController.text = '';
                      _pwController.text = '';
                    },
                  ),
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      element.name = _nameController.text;
                      element.id = _idController.text;
                      element.pw = _pwController.text;
                      setState(() {
                        SpDatasave()
                            .editData(element)
                            .then((value) => updatescreen());
                      });
                      _nameController.text = '';
                      _idController.text = '';
                      _pwController.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
        });
  }

  //데이터 삭제 확인용 다이얼로그 구현
  void confirmDeleteAlert(element) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Delete"),
                content: const Text("Are you sure you want to delete?"),
                actions: [
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 12, color: Colors.lightBlue),
                    ),
                    onPressed: () {
                      updatescreen();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      setState(() {
                        SpDatasave()
                            .removeData(element.idx)
                            .then((value) => updatescreen());
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
        });
  }

  List<Widget> showLists() {
    List<Widget> content = [];
    dataSetss.forEach((element) {
      content.add(
        Dismissible(
          background: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.lightBlueAccent,
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.edit,
              size: 36,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              size: 36,
              color: Colors.white,
            ),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              updatescreen();
              showEditAlert(element);
              print("startToEnd $element");
            } else {
              updatescreen();
              confirmDeleteAlert(element);
              print("endToStart" + element.idx.toString());
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              border: Border.all(color: Colors.lightBlue[100]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Expanded(child: Text(element.name, style: nameStyle)),
              Column(
                children: [
                  Text(
                    element.id,
                    style: idpwStyle,
                    textAlign: TextAlign.right,
                  ),
                  Text(element.pw,
                      style: idpwStyle, textAlign: TextAlign.right),
                ],
              ),
            ]),
          ),
        ),
      );
    });
    return content;
  }

  Future saveData() async {
    int idx = SpDatasave().getCounter() + 1;
    Datasets datas = Datasets(idx, _nameController.text.toString(),
        _idController.text.toString(), _pwController.text.toString());
    SpDatasave().writeData(datas).then((value) => updatescreen());
    SpDatasave().setCounter();
    _nameController.text = '';
    _idController.text = '';
    _pwController.text = '';
    setState(() {});
  }

  List<Datasets> readDatas() {
    List<Datasets> datas = SpDatasave().readData();
    return datas;
  }

  void updatescreen() {
    dataSetss = readDatas();
    setState(() {});
  }
}
