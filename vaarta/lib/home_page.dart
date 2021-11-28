
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaarta/login_controller.dart';
import 'package:vaarta/save_articles.dart';
import 'package:vaarta/sources_screen.dart';

import 'categories_screen.dart';
import 'home_feeds.dart';

class LoginPage extends StatelessWidget {

  final controller = Get.put(LoginController());
  

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Align(
         alignment: Alignment.bottomCenter,
         child: Obx(() {
           if(controller.googleAccount.value == null) {
             return buildLoginButton();
           } else {
              return vaartaTabs();
           }
         }), 
       ),
       );
     
   }

   Widget vaartaTabs() {

    const List<Tab> myTabs = <Tab>[
              Tab(
                text: 'Home Feeds',
                icon: Icon(Icons.view_headline, size: 20.0)
                
              ),
              Tab(text:'Sources' ,icon: Icon(Icons.view_module, size: 20.0) ),
              Tab(text:'Category' ,icon: Icon(Icons.explore, size: 20.0) ),
              Tab(text:'SavedArticles' ,icon: Icon(Icons.bookmark, size: 20.0) ),
            ];
      
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vaarta"),
          actions: <Widget>[
    Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () { controller.logout(); },
        child: const Icon(
          Icons.logout,
          size: 26.0,
        ),
      )
    ),
  ],
          bottom: const TabBar(
            tabs: myTabs,
          ),
        ),
        body: const TabBarView(
          children: [
            Scaffold(
              body: HomeFeeds()
            ),
            Scaffold(
              body: SourcesScreen()
            ),
            Scaffold(
              body: CategoriesScreen()
            ),
            Scaffold(
              body: SaveArticles()
            )
          ]
        ),
      ),
    );
   }

   Widget buildLoginButton() {

     return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/logo.png',
                        height: 160,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'The NEWS Application',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FloatingActionButton.extended(
           onPressed: (){
             controller.login();
           },
           //icon: Icon(Icons.security),
           icon: Image.asset(
             'assets/google_logo.png',
             height: 32,
             width: 32
             ),
           label: const Text("Sign in with Google"),
           backgroundColor: Colors.white,
           foregroundColor: Colors.black
         )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ); 

   }

}