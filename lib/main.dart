import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:math';

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
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List pokemonList = [];
  final List<Color> colors = List.generate(100,
      (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    fetchPokemonData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemonData() async {
    var dio = Dio();
    try {
      var response =
          await dio.get('https://pokeapi.co/api/v2/pokemon?limit=100');
      setState(() {
        pokemonList = response.data['results'];
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> fetchPokemonDetails(String url, Color cardColor) async {
    var dio = Dio();
    try {
      var response = await dio.get(url);
      _animationController.reset();
      _animationController.forward();
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, anim1, anim2) {
          return ScaleTransition(
            scale: _animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                color: cardColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(thickness: 2, color: Colors.black),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        response.data['name'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Divider(thickness: 2, color: Colors.black),
                    const SizedBox(height: 10),
                    Image.network(
                      response.data['sprites']['front_default'],
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.black),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Height: ${response.data['height']}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Weight: ${response.data['weight']}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Base Experience: ${response.data['base_experience']}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.black),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _animationController
                              .reverse()
                              .then((value) => Navigator.of(context).pop());
                        },
                        child: const Text('Kapat'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
              parent: anim1,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      );
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokemons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: pokemonList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                final id = index + 1;
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
                return GestureDetector(
                  onTap: () =>
                      fetchPokemonDetails(pokemon['url'], colors[index]),
                  child: Card(
                    color: colors[index],
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 2, color: Colors.black),
                        Text(
                          pokemon['name'].toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
