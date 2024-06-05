import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _counter = 0;

  final List<Widget> _children = [ListViewPage(0), CounterPage(0)];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _children[0] = ListViewPage(_counter);
      _children[1] = CounterPage(_counter);
    });
  }

  void updateCounter(int counter) {
    setState(() {
      _counter = counter;
      _children[0] = ListViewPage(_counter);
      _children[1] = CounterPage(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 133, 169, 187),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.grey[400], size: 25),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.countertops),
            label: 'Counter',
          ),
        ],
      ),
    );
  }
}

class ListViewPage extends StatefulWidget {
  final int itemCount;
  ListViewPage(this.itemCount);

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _items = data.take(widget.itemCount).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 133, 169, 187),
        title: const Text(
          'List View',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 175, 211, 228), // Set your desired background color here
        child: _items.isNotEmpty
            ? ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _items[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(_items[index]['body']),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  final int initialCounter;
  CounterPage(this.initialCounter);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter;

  _CounterPageState() : _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounter;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Access the parent state to update the counter value
    (context.findAncestorStateOfType<_HomePageState>())
        ?.updateCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 78, 148, 206),
        title: const Text(
          'Counter',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        color: Color.fromARGB(
            255, 188, 207, 220), // Set your desired background color here
        child: Center(
          child: Text(
            'Counter: $_counter',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add, color: Colors.blueGrey),
      ),
    );
  }
}
