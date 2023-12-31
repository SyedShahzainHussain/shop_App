import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Products.dart";
import "package:provider/provider.dart";

import "EditProductScreen.dart";

class UserProductItem extends StatelessWidget {
  // VoidCallback remove;
  final String title, imageUrl, id;
  UserProductItem({
    super.key,
    // required this.remove,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    var scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: ()  async{
                  try {
                   await  Provider.of<Products>(context, listen: false).remove(id);
                  } catch (e) {
                   await scaffold.showSnackBar(
                        SnackBar(content: Text("Deleting Failed",textAlign: TextAlign.center,)));
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
