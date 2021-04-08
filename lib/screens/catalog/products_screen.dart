import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:jaansay_public_user/widgets/catalog/product_detail_bottom_sheet.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsScreen extends StatelessWidget {
  productCard(int index, CatalogProvider catalogProvider) {
    Product product = catalogProvider.products[index];

    return InkWell(
      onTap: () {
        catalogProvider.selectedProductIndex = index;

        Get.bottomSheet(
          ProductDetailBottomSheet(),
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
                  product.cpPhoto.length == 0 ? '' : product.cpPhoto.first,
                  assetLink: Constants.productHolderURL,
                ),
                if (product.cpPriority == 1 || product.cpStock == 0)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.cpStock == 0)
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
                        if (product.cpPriority == 1)
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
            product.cpName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
          ),
          if (product.cpDescription.length > 0)
            Text(
              product.cpDescription.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
          const SizedBox(
            height: 4,
          ),
          CatalogDiscountTextWidget(product.cpCost, product.cpDiscountCost)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    if (!catalogProvider.initProduct) {
      catalogProvider.initProduct = true;
      catalogProvider.getAllProducts();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: catalogProvider.isProductSearch
            ? Container(
                child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: "Enter product name"),
                  autofocus: true,
                  onChanged: (val) {
                    catalogProvider.productSearchValue = val;
                    catalogProvider.getAllProducts();
                  },
                ),
              )
            : Text(
                catalogProvider
                    .categories[catalogProvider.selectedCategoryIndex].ccName,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
        actions: [
          !catalogProvider.isProductSearch
              ? InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    catalogProvider.isProductSearch = true;
                    catalogProvider.notify();
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
                    catalogProvider.productSearchValue = '';
                    catalogProvider.isProductSearch = false;
                    catalogProvider.notify();
                    catalogProvider.getAllProducts();
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
      body: catalogProvider.isProductLoad
          ? CustomLoading("Please wait")
          : Container(
              child: catalogProvider.products.length == 0
                  ? CustomErrorWidget(
                      title: "No products found",
                      iconData: Icons.exposure_zero,
                    )
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: ClassicHeader(),
                      onRefresh: () {
                        catalogProvider.currentProductPage = 1;
                        catalogProvider.getAllProducts();
                      },
                      onLoading: () {
                        catalogProvider.currentProductPage++;
                        catalogProvider.getAllProducts();
                      },
                      controller: catalogProvider.productRefreshController,
                      child: GridView.builder(
                        itemCount: catalogProvider.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.4,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: Get.height * 0.02),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        itemBuilder: (context, index) {
                          return productCard(index, catalogProvider);
                        },
                      ),
                    ),
            ),
    );
  }
}
