class WidgetBot extends StatefulWidget {
  const WidgetBot({Key? key}) : super(key: key);

  @override
  _WidgetBotState createState() => _WidgetBotState();
}

class _WidgetBotState extends State<WidgetBot> {
  int _currentIndex = 0;

  final List<Widget> body = [
    SliderP(),
    Icon(Icons.menu),
    Icon(Icons.map),
    Icon(Icons.loyalty),
    Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Menu',
            icon: Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            label: 'Maps',
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: 'Loyalty',
            icon: Icon(Icons.loyalty),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
