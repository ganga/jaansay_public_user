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
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withAlpha(180),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Icon(
        Icons.add,
        color: Colors.black.withAlpha(180),
      ),
    );
  }

  gridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: isLoad ? count.length : officials.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: Get.height * 0.02),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Messages",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black.withAlpha(180),
            ),
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
      child: InkWell(
        onTap: onTap,
        radius: 30,
        child: Container(
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                width: 50,
                height: 50,
                clipBehavior: Clip.hardEdge,
                child: CustomNetWorkImage(official?.photo ?? ''),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: Text(
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
