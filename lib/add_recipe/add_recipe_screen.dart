import 'package:flutter/material.dart';

class AddRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Add Recipe',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: Column(
          children: [
            // 画像
            Container(
              height: 250,
              width: double.infinity,
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[400],
              ),
              child: Icon(Icons.add_photo_alternate_outlined),
            ),
            // 評価
            Container(
              height: 30,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // color: Colors.grey[400],
              ),
              child: Text(
                '★★★☆☆',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            // レシピ名
            Container(
              color: Colors.blue,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    "レシピ名",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  TextField(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
