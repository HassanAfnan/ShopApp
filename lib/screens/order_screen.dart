import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/orders.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading? Center(child: CircularProgressIndicator()) :ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) => OrderWidget(orderData.orders[i])),
    );
  }
}
