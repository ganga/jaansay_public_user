import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashList extends StatelessWidget {
  final List<Official> officials;
  final String title;
  final bool isLoad;
  final Function onTapAdd;
  final Function onTap;

  DashList(
      {this.officials, this.title, this.isLoad, this.onTapAdd, this.onTap});

  final List count = List.generate(8, (index) => index);

  addListItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 18, top: 5),
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: Get.theme.primaryColor, blurRadius: 3, spreadRadius: 0.2)
      ]),
      constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTapAdd,
          child: Icon(
            Icons.add,
            color: Colors.black.withAlpha(180),
          ),
        ),
      ),
    );
  }

  gridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: isLoad ? count.length : officials.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80, crossAxisSpacing: 16, mainAxisSpacing: 20),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      itemBuilder: (context, index) => isLoad
          ? _DashListItem()
          : onTapAdd == null
              ? _DashListItem(
                  official: officials[index],
                  onTap: () => onTap(index),
                )
              : index == officials.length - 1
                  ? addListItem()
                  : _DashListItem(
                      official: officials[index],
                      onTap: () => onTap(index),
                    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.65),
                  letterSpacing: 0.45),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: isLoad
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: gridView(),
                    )
                  : gridView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashListItem extends StatelessWidget {
  final Official official;
  final Function onTap;

  _DashListItem({this.official, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 50,
                height: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomNetWorkImage(official?.photo ?? '')),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: AutoSizeText(
                  official?.officialsName ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
