import 'package:flutter/material.dart';
import 'package:photo_book_application/screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:photo_book_application/widget/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<List<String>> fetchImages(String keyword, int index) async {
    final response = await http.get(
      Uri.parse('https://source.unsplash.com/400x225/?$keyword&sig=$index'),
    );

    if (response.statusCode == 200) {
      return [response.request!.url.toString()];
    } else {
      throw Exception('Failed to fetch image');
    }
  }

  Future<void> logout() async {
    // await UserPreferences.clearUserCredentials();
    // Navigate to the login screen or perform other actions
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 50),
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                logout();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                prefix: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchController.clearComposing();
                    });
                  },
                ),
                hintText: 'Search',
                controller: _searchController,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: 1000,
                width: 1000,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final keyword = _searchController.text.trim();
                    return FutureBuilder<List<String>>(
                      future: fetchImages(keyword, index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Image.network(
                            snapshot.data![0], // URL of the fetched image
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
