import 'package:flutter/material.dart';
import 'pokemons.dart';
import 'pokemon_detail.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon App',
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        fontFamily: 'Comfortaa',
      ),
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double money = 6.0;
  int _currentIndex = 0;
  List caughtPokemons = [];
  int _clickCount = 0;
  static const int _requiredClicks = 30;

  Widget _buildMyPokemonsPage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: caughtPokemons.isEmpty
          ? const Center(
              child: Text(
                'You haven\'t caught any Pokemon yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: caughtPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = caughtPokemons[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  color: const Color(0xFF59463F),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF261B15),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          pokemon['sprites']['front_default'],
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Color(0xFFFAFAFA));
                          },
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PokemonDetailPage(pokemon: pokemon)),
                      );
                    },
                    title: Text(
                      pokemon['name'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                    subtitle: Text(
                      'Type: ${pokemon['types'][0]['type']['name']}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildGetPokeballsPage() {
    double progress = _clickCount / _requiredClicks;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _clickCount++;
                  if (_clickCount >= _requiredClicks) {
                    _clickCount = 0;
                    money += 1;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(40),
                backgroundColor: Colors.red,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.catching_pokemon,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get Pokeballs\n$_clickCount/$_requiredClicks',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55A603),
        title: Center(
          child: Image.asset(
            'assets/Newlogo.png',
            height: 45,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.catching_pokemon, color: Colors.red),
                      const SizedBox(width: 5),
                      Text(
                        money.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Pokemons'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: const Text('My Pokemons'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Get Pokeballs'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PokemonsPage(
            money: money,
            onMoneyChanged: (newValue) {
              setState(() {
                money = newValue;
              });
            },
            onPokemonCaught: (pokemon) {
              setState(() {
                caughtPokemons.add(pokemon);
              });
            },
          ),
          _buildMyPokemonsPage(),
          _buildGetPokeballsPage(),
        ],
      ),
    );
  }
}
