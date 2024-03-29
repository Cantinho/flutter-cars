import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/login/login_page.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/data/services/firebase_service.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<FirebaseUser> userFuture = FirebaseAuth.instance.currentUser();

    return SafeArea(
      child: Container(
        child: Drawer(
          child: Container(
            color: Colors.black87,
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.pink,
                  child: FutureBuilder<FirebaseUser>(
                    future: userFuture,
                    builder: (context, snapshot) {
                      FirebaseUser user = snapshot.data;
                      return _header(user);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.star, color: Colors.grey),
                  title:
                      Text("Favorites", style: TextStyle(color: Colors.grey)),
                  subtitle: Text(
                    "more info...",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    print("Item 1");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.grey),
                  title: Text("Help", style: TextStyle(color: Colors.grey)),
                  subtitle: Text("more info...",
                      style: TextStyle(color: Colors.grey)),
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
                  onTap: () => _onClickLogout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader _header(final FirebaseUser user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.only(bottom: 0.0),
      decoration: BoxDecoration(
        color: Colors.black54,
      ),
      accountName: Text(
        user == null ? "" : user.displayName ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      accountEmail: Text(user == null ? "" : user.email ?? ""),


      currentAccountPicture: (user != null && user.photoUrl != null && user.photoUrl.isNotEmpty) ?
      CircleAvatar(
        child: ClipOval(child: CachedNetworkImage(imageUrl: user.photoUrl)),
        backgroundColor: Color.alphaBlend(Colors.black38, Colors.pink),
        //Use below to load image through network
        //backgroundImage: NetworkImage("https://avatars1.githubusercontent.com/u/5253073?s=460&v=4"),
      ) :
      CircleAvatar(
        backgroundImage: AssetImage("assets/images/tyre64.png"),
        backgroundColor: Color.alphaBlend(Colors.black38, Colors.pink),
      ),
    );
  }

  _onClickLogout(BuildContext context) {
    User.clear();
    FirebaseService().logout();
    push(context, LoginPage(), replace: true);
  }
}
