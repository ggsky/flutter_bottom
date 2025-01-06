import 'package:flutter/material.dart';
import 'package:flutter_bottom/bottom/bottom_bar_page.dart';
import 'package:flutter_bottom/safe/safe_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () => push(SafePage()),
            child: Text('拖动验证器'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => push(ButtomBarPage()),
            child: Text('有趣的底部导航'),
          ),
        ]),
      ),
    );
  }

  push(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
