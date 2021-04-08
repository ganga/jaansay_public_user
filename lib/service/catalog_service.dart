import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class CatalogService {
  DioService dioService = DioService();
  String userId = GetStorage().read("user_id").toString();

  getAllCategories(List<Category> categories, String officialId) async {
    final response = await dioService.getData("catalog/category/$officialId");
    if (response != null) {
      response['data']
          .map((e) => categories.add(Category.fromJson(e)))
          .toList();
    }
  }

  getProducts(List<Product> products, int ccId, String searchVal, int page,
      String officialId) async {
    final response = await dioService.getData(
        "catalog/product/official/$officialId/user/$userId/category/$ccId/${searchVal.length == 0 ? 'ALL' : searchVal}/$page");
    if (response != null) {
      response['data'].map((e) => products.add(Product.fromJson(e))).toList();
      return response['next'];
    }
    return null;
  }

  getCartProducts(List<Product> products, String officialId) async {
    final response = await dioService
        .getData("catalog/cart/official/$officialId/user/$userId");
    if (response != null) {
      response['data'].map((e) => products.add(Product.fromJson(e))).toList();
      return response['next'];
    }
    return null;
  }

  getProductById(String productId) async {
    final response = await dioService.getData("catalog/product/$productId");
    if (response != null) {
      return Product.fromJson(response['data'][0]);
    }
    return null;
  }

  getFeaturedProducts(List<Product> products, String officialId) async {
    final response =
        await dioService.getData("catalog/product/featured/$officialId");
    if (response != null) {
      response['data'].map((e) => products.add(Product.fromJson(e))).toList();
    }
  }

  getAllUserAddress(List<UserAddress> userAddresses) async {
    final response = await dioService.getData("catalog/address/user/$userId");
    if (response != null) {
      response['data']
          .map((e) => userAddresses.add(UserAddress.fromJson(e)))
          .toList();
    }
  }

  Future<bool> checkOrder(String officialId) async {
    final response = await dioService.getData("utility/official/$officialId");
    if (response != null) {
      List<OfficialUtility> officialUtilities = [];
      response['data']
          .map((e) => officialUtilities.add(OfficialUtility.fromJson(e)))
          .toList();
      bool isOrder = false;
      officialUtilities.map((ou) {
        if (ou.utilityId == 4) {
          isOrder = true;
        }
      }).toList();
      return isOrder;
    } else {
      return false;
    }
  }

  addItemToCart(String productId) async {
    await dioService
        .postData("catalog/cart", {"cp_id": productId, "user_id": userId});
  }

  updateCartQuantity(int quantity, int cartId) async {
    await dioService
        .patchData("catalog/cart", {"quantity": quantity, "cart_id": cartId});
  }

  deleteCartItem(int cartId) async {
    await dioService.deleteData("catalog/cart/item", data: {"cart_id": cartId});
  }
}
