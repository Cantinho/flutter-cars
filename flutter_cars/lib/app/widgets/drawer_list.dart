import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Drawer(
          child: Container(
            color: Colors.black87,
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.pink,
                  child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(bottom: 0.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                    ),
                    accountName: Text(
                      "Samirtf",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    accountEmail: Text("samirtf@email.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/tyre64.png"),
                      backgroundColor: Color.alphaBlend(Colors.black38, Colors.pink),
                      //Use below to load image through network
                      //backgroundImage: NetworkImage("https://avatars1.githubusercontent.com/u/5253073?s=460&v=4"),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.star, color: Colors.grey),
                  title: Text("Favorites", style: TextStyle(color: Colors.grey)),
                  subtitle: Text("more info...", style: TextStyle(color: Colors.grey),),
                  trailing: Icon(Icons.arrow_forward, color: Colors.grey,),
                  onTap: () {
                    print("Item 1");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.grey),
                  title: Text("Help", style: TextStyle(color: Colors.grey)),
                  subtitle: Text("more info...", style: TextStyle(color: Colors.grey)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                  onTap: () {
                    print("Item 2");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.grey),
                  title: Text("Logout", style: TextStyle(color: Colors.grey)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                  onTap: () {
                    print("Item 3");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
