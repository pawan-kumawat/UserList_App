import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/user_provider.dart';
import 'models/user.dart';

// Main entry point of the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

// Main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListScreen(),
    );
  }
}

// User List Screen with search functionality
class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final filteredUsers = userProvider.users
        .where((user) => user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: userProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : userProvider.error != null
            ? Center(child: Text('Error: ${userProvider.error}'))
            : RefreshIndicator(
          onRefresh: () async {
            await userProvider.refreshUsers();
          },
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),

    );
  }
}
// User Detail Screen
class UserDetailScreen extends StatelessWidget {
  final User user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: ${user.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Website: ${user.website}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Address:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('  Street: ${user.address.street}', style: TextStyle(fontSize: 16)),
            Text('  Suite: ${user.address.suite}', style: TextStyle(fontSize: 16)),
            Text('  City: ${user.address.city}', style: TextStyle(fontSize: 16)),
            Text('  Zipcode: ${user.address.zipcode}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Company:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('  Name: ${user.company.name}', style: TextStyle(fontSize: 16)),
            Text('  Catch Phrase: ${user.company.catchPhrase}', style: TextStyle(fontSize: 16)),
            Text('  BS: ${user.company.bs}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}