import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaansay_public_user/models/keys.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/catalog/category_screen.dart';
import 'package:jaansay_public_user/screens/community/contact_screen.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/screens/message/mesage_detail_screen.dart';
import 'package:jaansay_public_user/screens/referral/user_referral_screen.dart';
import 'package:jaansay_public_user/service/key_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/catalog/featured_section.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:jaansay_public_user/widgets/profile/profile_head_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OfficialsProfileHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    final officialFeedProvider =
        Provider.of<OfficialFeedProvider>(context, listen: false);

    final catalogProvider =
        Provider.of<CatalogProvider>(context, listen: false);

    Official official = officialProfileProvider
        .officials[officialProfileProvider.selectedOfficialIndex];

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06, vertical: Get.height * 0.03),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Get.width * 0.2,
                  width: Get.width * 0.2,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(child: CustomNetWorkImage(official.photo)),
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${official.officialsName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      InkWell(
                        onTap: () {
                          pushNewScreenWithRouteSettings(context,
                              screen: ReviewScreen(),
                              withNavBar: true,
                              settings: RouteSettings(
                                arguments: official,
                              ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBar(
                              itemSize: 20,
                              initialRating: official.averageRating ?? 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                  ),
                                  empty: Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                  )),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${official.totalRating})",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      if (official.officialsDescription != null)
                        Column(
                          children: [
                            Text(
                              "${official.officialsDescription}",
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ProfileHeadButton(
                  title: "${tr("Engage")}",
                  onTap: () {
                    if (official.isFollow == 1) {
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: MessageDetailScreen(),
                        withNavBar: false,
                        settings: RouteSettings(
                          arguments: [false, official],
                        ),
                      );
                    } else {
                      Get.rawSnackbar(
                          message:
                              "${tr('You need to follow this business to communicate with them')}");
                    }
                  },
                ),
                if (official.isCatalog == 1)
                  const SizedBox(
                    width: 10,
                  ),
                if (official.isCatalog == 1)
                  ProfileHeadButton(
                    title: "${tr("View Shop")}",
                    onTap: () {
                      catalogProvider.clearData(allData: true);
                      catalogProvider.selectedOfficial = official;
                      pushNewScreen(
                        context,
                        screen: CategoryScreen(),
                        withNavBar: false,
                      );
                    },
                  ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileHeadButton(
                  title: official.isFollow == 1 ? "Following" : "Follow",
                  onTap: () {
                    if (official.isFollow == 0) {
                      officialProfileProvider.followOfficial(
                          officialFeedProvider: officialFeedProvider);
                    }
                  },
                  isColor: official.isFollow == 0,
                ),
                SizedBox(
                  width: 10,
                ),
                ProfileHeadButton(
                    title: "${tr("Contact")}",
                    onTap: () {
                      pushNewScreenWithRouteSettings(context,
                          screen: ContactScreen(),
                          settings: RouteSettings(arguments: official));
                    }),
                SizedBox(
                  width: 10,
                ),
                ProfileHeadButton(
                  title: "${tr("Reviews")}",
                  onTap: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      screen: ReviewScreen(),
                      withNavBar: true,
                      settings: RouteSettings(
                        arguments: official,
                      ),
                    );
                  },
                ),
              ],
            ),
            if (official.isReferral != null && official.isFollow == 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Refer & Earn",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                      "Generate referral link and share this personalised link directly with your friends."),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      ProfileHeadButton(
                        isColor: true,
                        title: "${tr("Start Referring")}",
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: UserReferralScreen(official),
                            withNavBar: false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            if (official.isFollow == 1)
              _OfficialDocumentSection(official.officialsId),
            if (official.isCatalog == 1) FeatureSection(official),
            if (official.kmId != null && official.isFollow == 1)
              _KeySection(official)
          ],
        ),
      ),
    );
  }
}

class _KeySection extends StatefulWidget {
  final Official official;

  _KeySection(this.official);

  @override
  __KeySectionState createState() => __KeySectionState();
}

class __KeySectionState extends State<_KeySection> {
  List<KeyMaster> keyMasters = [];

  KeyService keyService = KeyService();
  int curIndex = 0;
  bool isLoad = true;
  PageController _pageController = PageController();
  double pageHeight = 180;
  TextEditingController controller = TextEditingController();
  DateTime tempDate;
  bool isAnswerAll = false;
  int totalAnswered = 0;

  getOfficialKeysById() async {
    await keyService.getKeysByOfficialIdForUser(
        keyMasters, widget.official.officialsId);
    if (keyMasters[curIndex].ktId == 1) {
      pageHeight = 180 + keyMasters[curIndex].optionIds.length * 50.0;
    } else {
      pageHeight = 180;
    }
    controller.clear();
    if (keyMasters[curIndex].answer != null) {
      if (keyMasters[curIndex].ktId == 3) {
        controller.text = keyMasters[curIndex].answer;
      } else if (keyMasters[curIndex].ktId == 2) {
        controller.text = DateFormat("dd MMMM yyyy")
            .format(DateTime.parse(keyMasters[curIndex].answer));
      }
    } else {
      controller.text = '';
    }
    tempDate = null;
    checkAnswer();

    isLoad = false;
    setState(() {});
  }

  _datePicker() async {
    tempDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
      helpText: "Choose the date",
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (tempDate != null) {
      controller.text = DateFormat("dd MMMM yyyy").format(tempDate);
      setState(() {});
    }
  }

  checkAnswer() {
    totalAnswered = 0;
    isAnswerAll = true;
    keyMasters.map((e) {
      if (e.answer == null) {
        isAnswerAll = false;
      } else {
        totalAnswered++;
      }
    }).toList();
    if (!isLoad && isAnswerAll) {
      Get.rawSnackbar(
          message:
              "Thank you for your time. You will be getting personalised offers from this business.");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOfficialKeysById();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad || isAnswerAll
        ? SizedBox.shrink()
        : Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(isAnswerAll
                    ? "You have answered all the questions"
                    : "Answer these questions to avail offers and benefits from this business."),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: pageHeight,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (val) {
                      curIndex = val;
                      if (keyMasters[curIndex].ktId == 1) {
                        pageHeight =
                            180 + keyMasters[curIndex].optionIds.length * 60.0;
                      } else {
                        pageHeight = 180;
                      }
                      controller.clear();
                      if (keyMasters[curIndex].answer != null) {
                        if (keyMasters[curIndex].ktId == 3) {
                          controller.text = keyMasters[curIndex].answer;
                        } else if (keyMasters[curIndex].ktId == 2) {
                          controller.text = DateFormat("dd MMMM yyyy").format(
                              DateTime.parse(keyMasters[curIndex].answer));
                        }
                      } else {
                        controller.text = '';
                      }
                      tempDate = null;
                      setState(() {});
                    },
                    children: keyMasters.map((key) {
                      return SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Question",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                key.name,
                                style: TextStyle(fontSize: 16),
                              ),
                              if (key.description.length > 0)
                                Text(key.description),
                              const SizedBox(
                                height: 8,
                              ),
                              if (key.ktId == 2)
                                Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Your Answer",
                                        hintText: "Click here to add a date"),
                                    readOnly: true,
                                    controller: controller,
                                    onTap: () {
                                      if (key.answer == null) {
                                        _datePicker();
                                      }
                                    },
                                  ),
                                ),
                              if (key.ktId == 3)
                                Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Your Answer",
                                        hintText: "Enter your answer here"),
                                    readOnly: key.answer != null,
                                    controller: controller,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                              if (key.ktId == 1)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: key.options.map((e) {
                                    int index = key.options.indexOf(e);
                                    return Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        child: Material(
                                          color: e == key.answer
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1)
                                              : Colors.transparent,
                                          child: RadioListTile(
                                            onChanged: (val) {
                                              if (key.answer == null) {
                                                key.answer = e;
                                                checkAnswer();

                                                setState(() {});
                                                keyService.addKeyAnswer(
                                                    kmId: key.kmId,
                                                    optionId:
                                                        key.optionIds[index],
                                                    answer: e);
                                                _pageController.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeIn);
                                              }
                                            },
                                            title: Text(e),
                                            groupValue: key.answer,
                                            value: e,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ));
                                  }).toList(),
                                ),
                              const SizedBox(
                                height: 8,
                              ),
                              (key.ktId == 1)
                                  ? SizedBox.shrink()
                                  : (key.answer == null)
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (key.ktId == 3) {
                                                if (controller.text.length >
                                                    0) {
                                                  key.answer = controller.text;
                                                  checkAnswer();

                                                  setState(() {});
                                                  keyService.addKeyAnswer(
                                                      kmId: key.kmId,
                                                      optionId: 0,
                                                      answer: controller.text);
                                                  _pageController.nextPage(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      curve: Curves.easeIn);
                                                }
                                              } else {
                                                if (tempDate != null) {
                                                  key.answer =
                                                      tempDate.toString();
                                                  tempDate = null;
                                                  checkAnswer();
                                                  setState(() {});
                                                  keyService.addKeyAnswer(
                                                      kmId: key.kmId,
                                                      optionId: 0,
                                                      answer: key.answer);
                                                  _pageController.nextPage(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      curve: Curves.easeIn);
                                                }
                                              }
                                            },
                                            child: Text("Submit"),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    Text("$totalAnswered/${keyMasters.length}"),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Row(
                        children: keyMasters
                            .map(
                              (e) => Flexible(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  height: 8,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: e.answer == null
                                        ? Colors.transparent
                                        : Colors.green,
                                    border: Border.all(
                                        color: curIndex == keyMasters.indexOf(e)
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                        width: curIndex == keyMasters.indexOf(e)
                                            ? 1
                                            : 0.5),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}

class _OfficialDocumentSection extends StatefulWidget {
  final int officialId;

  _OfficialDocumentSection(this.officialId);

  @override
  __OfficialDocumentSectionState createState() =>
      __OfficialDocumentSectionState();
}

class __OfficialDocumentSectionState extends State<_OfficialDocumentSection> {
  bool isLoad = true;
  List<OfficialDocument> officialDocuments = [];
  OfficialService officialService = OfficialService();

  getAllDocuments() async {
    isLoad = true;
    setState(() {});
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments, widget.officialId.toString());
    isLoad = false;
    setState(() {});
  }

  pickImage(OfficialDocument officialDocument) async {
    File _image;

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1000,
          maxWidth: 1000,
          compressFormat: ImageCompressFormat.jpg,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        _image = File(croppedFile.path);
        sendData(_image, officialDocument);
      } else {
        isLoad = false;
        setState(() {});
      }
    } else {
      isLoad = false;
      setState(() {});
    }
  }

  sendData(File image, OfficialDocument officialDocument) async {
    isLoad = true;
    setState(() {});
    OfficialService officialService = OfficialService();
    await officialService.addUserDocument(
        image,
        officialDocument.officialId.toString(),
        officialDocument.docId.toString());
    getAllDocuments();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Container()
        : officialDocuments.length == 0
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Documents requested from business",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: officialDocuments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Text(officialDocuments[index].docName)),
                              (officialDocuments[index].isVerified == 0)
                                  ? Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: officialDocuments[index]
                                                        .isDocument ==
                                                    0
                                                ? Theme.of(context).primaryColor
                                                : Colors.black,
                                            width: 0.5),
                                        color: officialDocuments[index]
                                                    .isDocument ==
                                                0
                                            ? Theme.of(context).primaryColor
                                            : Colors.black.withOpacity(0.01),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (officialDocuments[index]
                                                    .isDocument ==
                                                0) {
                                              pickImage(
                                                  officialDocuments[index]);
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  officialDocuments[index]
                                                              .isDocument ==
                                                          0
                                                      ? "Upload Document"
                                                      : "Pending Approval",
                                                  style: TextStyle(
                                                      color: officialDocuments[
                                                                      index]
                                                                  .isDocument ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.black),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).tr(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : (officialDocuments[index].isVerified == 1)
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
  }
}
