import 'package:flutter/material.dart';
import 'package:projekakhirprak/screens/exhibition_screen.dart';
import 'package:projekakhirprak/screens/garage_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String? imageUrl;

  const HomeScreen({
    super.key,
    required this.username,
    this.imageUrl,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ExhibitionScreen(), // Placeholder for Pameran Screen
    GarageScreen(),     // Placeholder for Garasi Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String appBarTitleText;
    if (_selectedIndex == 0) {
      appBarTitleText = 'Pameran Mobil';
    } else {
      appBarTitleText = 'Garasi Mobil';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl!),
                  radius: 18,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading profile image: $exception');
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.account_circle, size: 36, color: theme.primaryColor),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Halo, ${widget.username}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    appBarTitleText,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Pameran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.garage),
            label: 'Garasi',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
} 