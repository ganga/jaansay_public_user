import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/catalog/product_detail_bottom_sheet.dart';
import 'package:jaansay_public_user/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsScreen extends StatefulWidget {
  final Official official;
  final Category category;

  ProductsScreen({this.official, this.category});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  int currentProductPage = 1;
  CatalogService catalogService = CatalogService();
  RefreshController productRefreshController = RefreshController();
  bool isLoad = true;
  String productSearchValue = '';
  bool isProductSearch = false;

  getAllProducts() async {
    if (currentProductPage == 1) {
      products.clear();
      productRefreshController.resetNoData();
    }
    products.clear();
    final response = await catalogService.getProducts(
        products,
        widget.category.ccId,
        productSearchValue,
        currentProductPage,
        widget.official.officialsId.toString());
    productRefreshController.refreshCompleted();
    productRefreshController.loadComplete();
    if (response == null) {
      productRefreshController.loadNoData();
    }
    isLoad = false;
    setState(() {});
  }

  productCard(int index) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          ProductDetailBottomSheet(index, products[index], widget.official),
          isScrollControlled: true,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomNetWorkImage(
                  products[index].cpPhoto.length == 0
                      ? ''
                      : products[index].cpPhoto.first,
                  assetLink: Constants.productHolderURL,
                ),
                if (products[index].cpPriority == 1 ||
                    products[index].cpStock == 0)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (products[index].cpStock == 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            decoration: BoxDecoration(color: Colors.red),
                            child: Text(
                              "Out of Stock",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        if (products[index].cpPriority == 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            decoration:
                                BoxDecoration(color: Get.theme.primaryColor),
                            child: Text(
                              "Featured",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            products[index].cpName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
          ),
          if (products[index].cpDescription.length > 0)
            Text(
              products[index].cpDescription.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
          const SizedBox(
            height: 4,
          ),
          CatalogDiscountTextWidget(
              products[index].cpCost, products[index].cpDiscountCost)
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: isProductSearch
            ? Container(
                child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: "Enter product name"),
                  autofocus: true,
                  onChanged: (val) {
                    productSearchValue = val;
                    getAllProducts();
                  },
                ),
              )
            : Text(
                widget.category.ccName,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
        actions: [
          !isProductSearch
              ? InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    isProductSearch = true;
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.search,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    productSearchValue = '';
                    isProductSearch = false;
                    setState(() {});
                    getAllProducts();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
        ],
      ),
      body: isLoad
          ? CustomLoading("Please wait")
          : Container(
              child: products.length == 0
                  ? CustomErrorWidget(
                      title: "No products found",
                      iconData: Icons.exposure_zero,
                    )
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: ClassicHeader(),
                      onRefresh: () {
                        currentProductPage = 1;
                        getAllProducts();
                      },
                      onLoading: () {
                        currentProductPage++;
                        getAllProducts();
                      },
                      controller: productRefreshController,
                      child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.4,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: Get.height * 0.02),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        itemBuilder: (context, index) {
                          return productCard(index);
                        },
                      ),
                    ),
            ),
    );
  }
}
