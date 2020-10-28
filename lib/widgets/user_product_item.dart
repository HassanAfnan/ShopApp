import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/admin/edit_product.dart';
import 'package:shopapp/provider/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final deletedata = Provider.of<Products>(context);
    return Column(
      children: [
        ListTile(
                title: Text(title),
                trailing: Container(
                width: 100,
                    child: Row(
                    children: [
                    IconButton(icon: Icon(Icons.edit),onPressed: (){
                       //Navigator.of(context).pushNamed(EditProduct.routeName,arguments: id);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(id)));
                    },color: Theme.of(context).primaryColor,),
                      IconButton(icon: Icon(Icons.delete),
                        onPressed: () async {
                           try{
                            await deletedata.deleteProduct(id);
                           }catch(error){
                             scaffold.showSnackBar(SnackBar(
                               content: Text('Deleting failed'),
                             ));
                           }
                       },
                        color: Colors.redAccent,),
                     ],
                    ),
                    ),
                leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                ),
            ),
        Divider()
      ],
    );
  }
}
