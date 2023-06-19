import 'package:jaansay_public_user/models/Announcement.dart';

import 'dio_service.dart';

class AnnouncementService {
  DioService dioService = DioService();

  Future<List<Announcement>> getAllAnnouncements(String constituencyKey) async{
    final response = await dioService.getData("announcements/constituencies/${constituencyKey}");
    List<Announcement> announcements = (response['data']['feeds'] as List).map( (ann)  {
      Announcement announcement = new Announcement();
      announcement.description = ann["description"];
      return announcement;
    }).toList();
    return announcements;
  }
}