import 'package:flutter/material.dart';
import 'package:food_app/provider/myprovider.dart';
import 'package:food_app/widgets/cart_product.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  MyProvider myProvider;
  GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();

  Widget cartScreenButton(context, double subTotal) {
    return Builder(builder: (ctx) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 50,
        width: 350,
        child: RaisedButton(
          onPressed: myProvider.getTotalCount() <= 0
              ? null
              : () async {
                  await Provider.of<MyProvider>(context, listen: false)
                      .addOrder(
                    myProvider.allCartProducts.toList(),
                    myProvider.getTotalCount(),
                  );

                  myProvider.allCartProducts.clear();
                  Scaffold.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text("successfull your check out"),
                      backgroundColor: Color(0xff6cc070),
                    ),
                  );
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Check Out ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                width: 85,
              ),
              Text(
                '\$${subTotal.toString()}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    });
  }

  Widget dissmis(BuildContext context, int index) {
    var allCartProduct = myProvider.allCartProductList;

    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete'),
              content: Text('Are you sure ?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(false);
                  },
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(true);
                  },
                  child: Container(
                    height: 40,
                    width: 70,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        myProvider.delete(
          index,
        );
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
              'Delete',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      child: CardProducts(
        productImage: allCartProduct[index].cartImage,
        productName: allCartProduct[index].cartName,
        productPrice: allCartProduct[index].cartPrice,
        productQuantity: allCartProduct[index].cartQuantity,
        productColor: allCartProduct[index].cartColor,
      ),
    );
  }

  Widget checkOut({String name, double price}) {
    return ListTile(
      leading: Text(
        name,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        '\$$price',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            title: Text(
              'Shoping Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text('Click Checkout Buttom Then Send Your Order in Adman'),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView.builder(
                itemCount: myProvider.allCartProduct,
                itemBuilder: dissmis,
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Column(
                    children: [
                      checkOut(
                        name: 'Subtotal',
                        price: myProvider.getTotalCount(),
                      ),
                      checkOut(
                        name: 'TAX(20%)',
                        price: myProvider.getTotalCount(),
                      ),
                      cartScreenButton(
                        context,
                        myProvider.getTotalCount(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
