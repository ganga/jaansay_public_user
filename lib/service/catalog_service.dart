import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class CatalogService {
  DioService dioService = DioService();

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
        "catalog/product/official/$officialId/category/$ccId/${searchVal.length == 0 ? 'ALL' : searchVal}/$page");
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
}
