import 'package:flutter/material.dart';

class HomeBottomNavigationBarItem {
  HomeBottomNavigationBarItem({this.icon, this.text, this.action, this.name});

  IconData icon;
  String text;
  Function() action;
  String name;
}

class HomeBottomNavigationBar extends StatefulWidget {
  HomeBottomNavigationBar({
    this.items,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }

  final List<HomeBottomNavigationBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => HomeBottomNavigationBarState();
}

class HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
      );
    });

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem({
    HomeBottomNavigationBarItem item,
    int index,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    // print(name);
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => {
              setState(() => {_selectedIndex = index}),
              item.action(),
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    item.text,
                    style: TextStyle(color: color),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
