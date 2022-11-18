// 데이터셋 클래스 생성
class Datasets {
  int idx = 0;
  String name = '';
  String id = '';
  String pw = '';

  //생성자
  Datasets(this.idx, this.name, this.id, this.pw);

  //json을 받아서 변수에 저장
  Datasets.fromJson(Map<String, dynamic> dataMap) {
    idx = dataMap['idx'] ?? 1;
    name = dataMap['name'] ?? '';
    id = dataMap['id'] ?? '';
    pw = dataMap['pw'] ?? '';
  }
  // json형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
      'id': id,
      'pw': pw,
    };
  }

  getDatas() {}
}
