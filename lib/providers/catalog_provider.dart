import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/catalog/cart_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogProvider extends ChangeNotifier {
  CatalogService catalogService = CatalogService();

  RefreshController productRefreshController = RefreshController();

  bool isCategoryLoad = true, isProductLoad = true, isAddressLoad = true;
  bool initCategory = false, initProduct = false, initAddress = false;
  bool isProductSearch = false;
  bool isOrder = false;

  List<Product> products = [];
  List<Product> cartProducts = [];
  List<UserAddress> userAddresses = [];
  List<Category> categories = [];

  int currentProductPage = 1;
  String productSearchValue = '';
  Official selectedOfficial;
  int selectedAddressId, selectedProductIndex, selectedCategoryIndex;

  clearData({allData = false}) {
    isProductLoad = true;
    initProduct = false;
    isProductSearch = false;
    isAddressLoad = true;
    products.clear();
    productSearchValue = '';
    currentProductPage = 1;
    selectedProductIndex = null;
    initAddress = false;
    if (allData) {
      isCategoryLoad = true;
      initCategory = false;
      isOrder = false;
      cartProducts.clear();
      categories.clear();
      userAddresses.clear();
      selectedAddressId = null;

      selectedOfficial = null;
      selectedCategoryIndex = null;
    }
  }

  getAllCategories() async {
    isCategoryLoad = true;
    categories.clear();
    await checkIfOrder();
    await getCartProducts();
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

  Future getCartProducts() async {
    await catalogService.getCartProducts(
        cartProducts, selectedOfficial.officialsId.toString());
  }

  getAllUserAddress() async {
    await catalogService.getAllUserAddress(userAddresses);
    isAddressLoad = false;
    notifyListeners();
  }

  Future checkIfOrder() async {
    isOrder = await catalogService
        .checkOrder(selectedOfficial.officialsId.toString());
  }

  addItemToCart(String productId) async {
    products.map((e) {
      if (e.cpId == productId) {
        e.quantity = 1;
        cartProducts.add(e);
      }
    }).toList();
    notifyListeners();
    await catalogService.addItemToCart(productId);
    Get.rawSnackbar(
      message: "Product added to your cart.",
      mainButton: TextButton(
        onPressed: () {
          Get.to(CartScreen(), transition: Transition.rightToLeft);
        },
        child: Text(
          "View Cart",
        ),
      ),
    );
  }

  updateCartQuantity(int quantity, Product product) async {
    products.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = quantity;
      }
    }).toList();
    cartProducts.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = quantity;
      }
    }).toList();
    notifyListeners();
    await catalogService.updateCartQuantity(quantity, product.cartId);
  }

  deleteCartItem(Product product) async {
    cartProducts.removeWhere((element) => element.cpId == product.cpId);
    products.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = null;
        e.cartId = null;
      }
    }).toList();
    notifyListeners();
    await catalogService.deleteCartItem(product.cartId);
  }

  notify() {
    notifyListeners();
  }
}
