import 'package:jaansay_public_user/models/constituency.dart';
import 'package:jaansay_public_user/models/poll.dart';
import 'package:jaansay_public_user/models/poll_question.dart';
import 'package:jaansay_public_user/models/poll_question_option.dart';

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

  Future<List<Poll>> getPolls() async {
    final response = await dioService.getData("polls");
    List<Poll> polls = (response['data'] as List).map( (questionnaire)  {
      Poll poll = new Poll();
      poll.questions = (questionnaire['questions'] as List).map((question) {
        PollQuestion pollQuestion = new PollQuestion();
        pollQuestion.description = question['description'];
        pollQuestion.options = (question['options'] as List).map((questionOption){
          PollQuestionOption option = new PollQuestionOption();
          option.description = questionOption['description'];
          option.order = questionOption['order'];
          option.id = questionOption['id'];
          return option;
        }).toList();
        return pollQuestion;
      } ).toList();
      poll.description = questionnaire['description'];
      return poll;
    }).toList();
    return polls;
  }
}

