class Constants {
  static const productionUrl = "https://jaansay.com/api/";
  static const testUrl = "http://10.0.2.2:3000/api/";
  static const url = testUrl;
  static const photoUrl = "http://jaansay.com/media/publicusers/";

  static const notificationServerCode =
      "key=AAAAvyUrLIs:APA91bE8YAhAlWSGKVxOQnj1747vxLecE4ABRSh2ZpatGjp00rCLiQLUMaT6iyiijDyR5RLmiWxZeZ2-SdkGCSRK9NV0ZI_6AFVWMSGr7E3jk4dGEOfJ4sxmyWibiOA_msRIBVB2I1te";

  static const List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  static const List<String> yearList = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025'
  ];
  static const productHolderURL = "assets/images/productHolder.png";
}

enum CustomContentType { TEXT, IMAGE, VIDEO, PDF }

enum CustomMessageType { PRIVATE, BROADCAST, FEEDBACK, GRIEVANCE, SURVEY }
