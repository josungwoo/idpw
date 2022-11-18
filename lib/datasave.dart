import 'dart:convert'; // 이게 뭐야 json 떄문에 추가한듯
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idpw/datasets.dart';

class SpDatasave {
  //null safety
  static late SharedPreferences prefs;

  Future init() async {
    // prefs 를 초기화하는 함수
    prefs = await SharedPreferences.getInstance();
  }

  Future writeData(Datasets datas) async {
    // 데이터를 저장하는 함수
    // prefs에 키: idx(파라미터) 값: datas를 json형태로 저장
    prefs.setString(datas.idx.toString(), jsonEncode(datas.toJson()));
    print('writeData');
  }

  // 데이터를 읽어오는 함수
  List<Datasets> readData() {
    List<Datasets> list = []; // 데이터를 저장할 리스트 생성
    Set<String> keys = prefs.getKeys(); // prefs에 저장된 키값들을 가져옴
    keys.forEach((String key) {
      if (key != 'counter') {
        // 키값이 counter가 아니면
        Map<String, dynamic> dataMap = jsonDecode(prefs.getString(key)!);
        // 키값을 이용해 데이터를 가져옴
        Datasets data = Datasets.fromJson(dataMap);
        // 데이터를 Datasets 클래스로 변환
        list.add(data); // 리스트에 추가
      }
      // Datasets datas = Datasets.fromJson(json.decode(
      //     prefs.getString(key) ?? '')); // 읽어온 값을 json형태로 변환하고 Datasets 클래스에 저장
      // list.add(datas); // 리스트에 추가
    });
    return list; // json 형태의 데이터를 리스트로 반환 한다
  }

  Future setCounter() async {
    // 카운터를 저장하는 함수
    int counter =
        (prefs.getInt('counter') ?? 0) + 1; // 카운터가 없으면 0으로 초기화하고 1을 더함
    await prefs.setInt('counter', counter); // 카운터를 저장
  }

  int getCounter() {
    // 카운터를 가져오는 함수
    return prefs.getInt('counter') ?? 0; // 카운터가 없으면 0을 반환
  }

  Future removeData(int idx) async {
    // 데이터를 삭제하는 함수
    await prefs.remove(idx.toString()); // 키값을 이용해 데이터를 삭제
  }

  //editdata
  Future editData(Datasets datas) async {
    // 데이터를 저장하는 함수
    // prefs에 키: idx(파라미터) 값: datas를 json형태로 저장
    prefs.setString(datas.idx.toString(), jsonEncode(datas.toJson()));
    print('editData');
  }
}



// Datasets datas = Datasets.fromJson(json.decode(
//           prefs.getString(key) ?? '')); // 읽어온 값을 json형태로 변환하고 Datasets 클래스에 저장
//       list.add(datas); // 리스트에 추가
