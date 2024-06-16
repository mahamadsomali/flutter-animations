import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Items',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedListScreen(),
    );
  }
}

class AnimatedListScreen extends StatefulWidget {
  @override
  _AnimatedListScreenState createState() => _AnimatedListScreenState();
}

class _AnimatedListScreenState extends State<AnimatedListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  final List<Color> _colors = [
    Colors.red,
    Colors.black,
    Colors.grey[800]!,
    Colors.grey[400]!,
    Colors.white,
  ];
  final List<Widget> _tripTiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addTrips();
    });
  }

  void _addTrips() {
    print("Adding trips...");
    for (int i = 0; i < _items.length; i++) {
      _tripTiles.add(_buildItem(_items[i], _colors[i]));
      _listKey.currentState?.insertItem(_tripTiles.length - 1);
    }
  }

  Widget _buildItem(String item, Color color) {
    return Container(
      color: color,
      child: ListTile(
        onTap: () {
          print("Tapped on $item");
          _removeItem(_items.indexOf(item));
        },
        contentPadding: EdgeInsets.all(25),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ],
        ),
        leading: Icon(Icons.star, color: Colors.white),
      ),
    );
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildRemovedItem(removedItem, animation),
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildRemovedItem(String item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(1, 0),
        )),
        child: ListTile(
          title: Text(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Items'),
        backgroundColor: Color(0xFF008080),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _tripTiles.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            )),
            child: _tripTiles[index],
          );
        },
      ),
    );
  }
}
