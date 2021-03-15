import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/catalog/products_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/catalog/featured_section.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class CategoryScreen extends StatelessWidget {
  final Official official;

  CategoryScreen(this.official);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Catalog",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [FeatureSection(official), _CategorySection(official)],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatefulWidget {
  final Official official;

  _CategorySection(this.official);

  @override
  __CategorySectionState createState() => __CategorySectionState();
}

class __CategorySectionState extends State<_CategorySection> {
  CatalogService catalogService = CatalogService();

  bool isLoad = true;
  List<Category> categories = [];

  getAllCategories() async {
    isLoad = true;
    categories.clear();
    await catalogService.getAllCategories(
        categories, widget.official.officialsId.toString());
    isLoad = false;
    setState(() {});
  }

  categoryCard(int index) {
    return InkWell(
      onTap: () {
        Get.to(
            ProductsScreen(
              category: categories[index],
              official: widget.official,
            ),
            transition: Transition.rightToLeft);
      },
      child: Column(
        children: [
          Expanded(
            child: CustomNetWorkImage(
              categories[index].ccPhoto,
              assetLink: Constants.productHolderURL,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(
              categories[index].ccName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          isLoad
              ? CustomLoading("Please wait")
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1.2,
                      crossAxisSpacing: Get.width * 0.03,
                      mainAxisSpacing: Get.height * 0.02),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: categoryCard(index),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
