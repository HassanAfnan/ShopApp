import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/products.dart';
import 'package:shopapp/provider/product_provider.dart';


class EditProduct extends StatefulWidget {
  final String productId;
  EditProduct(this.productId);
  //static const routeName = '/edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final priceFocusNote = FocusNode();
  final descriptionFocusNote = FocusNode();
  final imageUrlController = TextEditingController();
  final imageFocusNote = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct = Product(id: null,title: '',price: 0,description: '',imageUrl: '');
  var isInit = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    imageFocusNote.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isInit) {
      final productID = widget.productId;
      if (productID != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).findById(productID);
        initValues = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          'imageUrl': ''
        };
        imageUrlController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl(){
    if(!imageFocusNote.hasFocus){
      if(imageUrlController.text.isEmpty){
        return;
      }
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    imageFocusNote.removeListener(updateImageUrl);
    priceFocusNote.dispose();
    descriptionFocusNote.dispose();
    imageUrlController.dispose();
    imageFocusNote.dispose();
    super.dispose();
  }

  Future<void> saveForm() async{
      final isValid = form.currentState.validate();
      if(!isValid){
        return;
      }
      form.currentState.save();
      setState(() {
        isLoading = true;
      });
      if(editedProduct.id != null){
       await Provider.of<Products>(context,listen: false)
           .updateProduct(editedProduct.id,editedProduct);
      }else{
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(editedProduct);
        }catch(error){
          await showDialog(context: context,builder: (ctx) => AlertDialog(
            title: Text("An Error Occurred"),
            content: Text("Something went wrong"),
            actions: [
              FlatButton(
                child: Text("Okay"),
                onPressed: (){
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ));
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: (){
              saveForm();
            },
            icon: Icon(Icons.save,color: Colors.white,),
          ),
        ],
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
         key: form,
          child: ListView(
           children: [
             TextFormField(
               initialValue: initValues['title'],
               validator: (value){
                 if(value.isEmpty){
                   return "Please provide a value";
                 }
                 return null;
               },
               decoration: InputDecoration(
                 labelText: 'Title',
               ),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(priceFocusNote);
               },
               onSaved: (value){
                 editedProduct = Product(title: value, price: editedProduct.price, description: editedProduct.description,imageUrl: editedProduct.imageUrl,id: editedProduct.id,isFavorite: editedProduct.isFavorite);
               },
             ),
             TextFormField(
               initialValue: initValues['price'],
               decoration: InputDecoration(
                 labelText: 'Price',
               ),
               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.next,
               focusNode: priceFocusNote,
               onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(descriptionFocusNote);
               },
               onSaved: (value){
                 editedProduct = Product(title: editedProduct.title, price: double.parse(value), description: editedProduct.description,imageUrl: editedProduct.imageUrl,id: editedProduct.id,isFavorite: editedProduct.isFavorite);
               },
               validator: (value){
                 if(value.isEmpty){
                   return 'Please enter a number';
                 }
                 if(double.tryParse(value) == null){
                   return 'Please enter avalid number';
                 }
                 if(double.parse(value) <= 0){
                   return 'Please enter number greater than zero';
                 }
                 return null;
               },
             ),
             TextFormField(
               initialValue: initValues['description'],
               validator: (value){
                 if(value.isEmpty){
                   return 'Please enter a description';
                 }
                 return null;
               },
               decoration: InputDecoration(
                 labelText: 'Description',
               ),
               maxLines: 3,
               keyboardType: TextInputType.multiline,
               focusNode: descriptionFocusNote,
               onSaved: (value){
                 editedProduct = Product(title: editedProduct.title, price: editedProduct.price, description: value,imageUrl: editedProduct.imageUrl,id: editedProduct.id,isFavorite: editedProduct.isFavorite);
               },
             ),
             Row(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 Container(
                   height: 100,
                   width: 100,
                   margin: EdgeInsets.only(right: 10,top: 8),
                   decoration: BoxDecoration(
                     border: Border.all(width: 1,color: Colors.grey)
                   ),
                   child: imageUrlController.text.isEmpty ? Text("Enter Image Url") : FittedBox(
                     child: Image.network(imageUrlController.text,
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
                 Expanded(
                   child: TextFormField(
                     //initialValue: initValues['imageUrl'],
                     validator: (value){
                       if(value.isEmpty){
                         return 'Please enter an image url';
                       }
                       if(!value.startsWith('http') && !value.startsWith('https')){
                         return 'Please enter a valid URL';
                       }
                       // if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                       //   return 'Please enter a valid image url';
                       // }
                       return null;
                     },
                     onFieldSubmitted: (_){
                       saveForm();
                     },
                     focusNode: imageFocusNote,
                     controller: imageUrlController,
                     decoration: InputDecoration(
                       labelText: 'Image Url',
                     ),
                     keyboardType: TextInputType.url,
                     textInputAction: TextInputAction.done,
                     onEditingComplete: (){
                       setState(() {

                       });
                     },
                     onSaved: (value){
                       editedProduct = Product(title: editedProduct.title, price: editedProduct.price, description: editedProduct.description,imageUrl: value,id: editedProduct.id,isFavorite: editedProduct.isFavorite);
                     },
                   ),
                 ),
               ],
             )
           ],
         ),
        ),
      ),
    );
  }
}
