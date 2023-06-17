import 'package:jaansay_public_user/models/constituency.dart';

import 'dio_service.dart';

class QuestionnaireService {
  DioService dioService = DioService();

  Future<List<Constituency>> getConstituencies() async {
    final response =   await dioService.getData("polls/constituencies");
    List<Constituency> constituencies = (response['data'] as List).map( (el)  {
      Constituency constituency = new Constituency(el['name']);
      return constituency;
    }).toList();
    constituencies.sort((a,b) => a.name.compareTo(b.name));
    return constituencies;
  }
}