import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogProvider extends ChangeNotifier {
  CatalogService catalogService = CatalogService();
  RefreshController productRefreshController = RefreshController();

  bool isCategoryLoad = true, isProductLoad = true;
  bool initCategory = false, initProduct = false;
  bool isProductSearch = false;

  List<Product> products = [];
  List<Category> categories = [];

  int currentProductPage = 1;
  String productSearchValue = '';
  Official selectedOfficial;
  int selectedProductIndex, selectedCategoryIndex;

  getAllCategories() async {
    isCategoryLoad = true;
    categories.clear();
    await catalogService.getAllCategories(
        categories, selectedOfficial.officialsId.toString());
    isCategoryLoad = false;
    notifyListeners();
  }

  getAllProducts() async {
    if (currentProductPage == 1) {
      products.clear();
      productRefreshController.resetNoData();
    }
    products.clear();
    final response = await catalogService.getProducts(
        products,
        categories[selectedCategoryIndex].ccId,
        productSearchValue,
        currentProductPage,
        selectedOfficial.officialsId.toString());
    productRefreshController.refreshCompleted();
    productRefreshController.loadComplete();
    if (response == null) {
      productRefreshController.loadNoData();
    }
    isProductLoad = false;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
