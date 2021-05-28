import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/catalog/cart_screen.dart';
import 'package:jaansay_public_user/screens/catalog/order_confirmed_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogProvider extends ChangeNotifier {
  CatalogService catalogService = CatalogService();

  RefreshController productRefreshController = RefreshController();

  bool isCategoryLoad = true,
      initInnerCategory = false,
      isProductLoad = true,
      isAddressLoad = true,
      isCartLoad = false;
  bool initCategory = false,
      initProduct = false,
      initAddress = false,
      isInnerCategoryLoad = true;
  bool isProductSearch = false;
  bool isOrder = false;

  List<Product> products = [];
  List<Product> cartProducts = [];
  List<UserAddress> userAddresses = [];
  List<Category> categories = [];
  List<Category> innerCategories = [];

  int currentProductPage = 1;
  String productSearchValue = '';
  Official selectedOfficial;
  int selectedAddressId,
      selectedProductIndex,
      selectedCategoryIndex,
      selectedInnerCategoryIndex;

  clearData({allData = false, bool isInner = false}) {
    isProductLoad = true;
    initProduct = false;
    isProductSearch = false;
    products.clear();
    productSearchValue = '';
    currentProductPage = 1;
    selectedProductIndex = null;
    isCartLoad = false;

    if (allData || isInner) {
      initInnerCategory = false;
      isInnerCategoryLoad = true;
      selectedInnerCategoryIndex = null;
      innerCategories.clear();
    }

    if (allData) {
      isCategoryLoad = true;
      initCategory = false;
      isOrder = false;
      cartProducts.clear();
      categories.clear();
      userAddresses.clear();
      initAddress = false;
      isAddressLoad = true;

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
        categories, selectedOfficial.officialsId.toString(), 0);
    isCategoryLoad = false;
    notifyListeners();
  }

  getAllInnerCategories() async {
    initInnerCategory = true;
    int id = selectedInnerCategoryIndex == null
        ? categories[selectedCategoryIndex].ccId
        : innerCategories[selectedInnerCategoryIndex].ccId;
    innerCategories.clear();

    await catalogService.getAllCategories(
        innerCategories, selectedOfficial.officialsId.toString(), id);
    isInnerCategoryLoad = false;
    notifyListeners();
  }

  getAllProducts() async {
    if (currentProductPage == 1) {
      products.clear();
      productRefreshController.resetNoData();
    }
    products.clear();
    int id = selectedInnerCategoryIndex == null
        ? categories[selectedCategoryIndex].ccId
        : innerCategories[selectedInnerCategoryIndex].ccId;
    final response = await catalogService.getProducts(
        products,
        id,
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
          Get.to(() => CartScreen(), transition: Transition.rightToLeft);
        },
        child: Text(
          "View Cart",
        ),
      ),
    );
  }

  addUserAddress(UserAddress userAddress) async {
    userAddresses.clear();
    isAddressLoad = true;
    notifyListeners();
    await catalogService.addUserAddress(userAddress);
    getAllUserAddress();
  }

  placeOrder() async {
    isCartLoad = true;
    notifyListeners();
    List<String> cpId = [];
    List<int> quantity = [];
    List<int> itemCost = [];
    List<int> itemDiscountCost = [];
    int totalCostWithoutDiscount = 0;
    int totalCost = 0;
    String orderId = MiscUtils.getRandomId(8).toUpperCase();

    cartProducts.map((e) {
      cpId.add(e.cpId);
      quantity.add(e.quantity);
      itemCost.add(e.cpCost * e.quantity);
      itemDiscountCost.add(e.cpDiscountCost * e.quantity);
      totalCostWithoutDiscount += e.cpCost * e.quantity;
      totalCost += e.cpDiscountCost == 0
          ? e.cpCost * e.quantity
          : e.cpDiscountCost * e.quantity;
    }).toList();

    await catalogService.addOrder(
        quantity: quantity,
        officialId: selectedOfficial.officialsId,
        addressId: selectedAddressId,
        orderId: orderId,
        cost: totalCostWithoutDiscount,
        deliveryTypeId: selectedAddressId == 0 ? 1 : 2,
        discountCount: totalCost,
        itemCost: itemCost,
        itemDiscountCost: itemDiscountCost,
        cpId: cpId);
    NotificationService notificationService = NotificationService();
    await notificationService.sendNotificationToUser(
        "New Order",
        "${GetStorage().read("user_name").toString()} has placed an order.",
        selectedOfficial.officialsId.toString(),
        {"type": "order"});
    Get.off(OrderConfirmedScreen(), transition: Transition.rightToLeft);
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
