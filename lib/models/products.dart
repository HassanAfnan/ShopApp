class Product {
   final String id;
   final String title;
   final String description;
   final double price;
   final String imageUrl;
   bool isFavorite;

   Product({
     this.id,
     this.title,
     this.description,
     this.imageUrl,
     this.price,
     this.isFavorite = false
   });
}