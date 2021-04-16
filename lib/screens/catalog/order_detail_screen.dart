import 'package:flutter/material.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:jaansay_public_user/widgets/catalog/home_delivery_section.dart';
import 'package:jaansay_public_user/widgets/catalog/pickup_section.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  OrderDetailScreen(this.order);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<OrderDetail> orderDetails = [];
  CatalogService catalogService = CatalogService();
  bool isLoad = true;

  getOrderDetails() async {
    await catalogService.getOrderDetails(
        widget.order.id.toString(), orderDetails);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Order Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.9),
                            children: <TextSpan>[
                              TextSpan(text: 'Order Status: '),
                              TextSpan(
                                  text:
                                      '${widget.order.statusName.toUpperCase()}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _AddressSection(widget.order),
                    ListView.builder(
                      itemCount: orderDetails.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _CartItem(orderDetails[index]);
                      },
                    ),
                    _PriceDetailSection(widget.order, orderDetails)
                  ],
                ),
              ),
            ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  final Order order;

  _AddressSection(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            order.deliveryTypeId == 1
                ? PickupSection(() {}, 0)
                : HomeDeliverySection(
                    () {},
                    order.deliveryTypeId,
                    order.deliveryTypeId,
                    UserAddress(
                        name: order.name,
                        address: order.address,
                        pincode: order.pincode,
                        city: order.city,
                        state: order.state)),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final OrderDetail orderDetail;

  _CartItem(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        child: CustomNetWorkImage(
                          orderDetail.productPhotos.length == 0
                              ? ''
                              : orderDetail.productPhotos.first,
                          assetLink: Constants.productHolderURL,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          orderDetail.cpName,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          orderDetail.cpDescription,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        CatalogDiscountTextWidget(
                            orderDetail.cost, orderDetail.discountCost)
                      ],
                    ),
                  ),
                ),
                Text("Qty: ${orderDetail.quantity}")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceDetailSection extends StatelessWidget {
  final Order order;
  final List<OrderDetail> orderDetails;

  _PriceDetailSection(this.order, this.orderDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              "PRICE DETAILS",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price (${orderDetails.length} items)"),
                    Text("₹${order.cost}")
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                if (order.cost - order.discountCost > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount"),
                      Text(
                        "₹${order.cost - order.discountCost}",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "₹${order.discountCost}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          if (order.cost - order.discountCost > 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "You saved ₹${order.cost - order.discountCost} on this order",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            )
        ],
      ),
    );
  }
}
