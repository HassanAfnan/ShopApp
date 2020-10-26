import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final priceFocusNote = FocusNode();
  final descriptionFocusNote = FocusNode();
  final imageUrlController = TextEditingController();
  final imageFocusNote = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    imageFocusNote.addListener(updateImageUrl);
    super.initState();
  }

  void updateImageUrl(){
    if(!imageFocusNote.hasFocus){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
         child: ListView(
           children: [
             TextFormField(
               decoration: InputDecoration(
                 labelText: 'Title',
               ),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(priceFocusNote);
               },
             ),
             TextFormField(
               decoration: InputDecoration(
                 labelText: 'Price',
               ),
               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.next,
               focusNode: priceFocusNote,
               onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(descriptionFocusNote);
               },
             ),
             TextFormField(
               decoration: InputDecoration(
                 labelText: 'Description',
               ),
               maxLength: 3,
               keyboardType: TextInputType.multiline,
               focusNode: descriptionFocusNote,
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
                   ),
                 )
               ],
             )
           ],
         ),
        ),
      ),
    );
  }
}
