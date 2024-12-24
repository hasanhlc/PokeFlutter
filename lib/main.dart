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

class _HomePageState extends State<HomePage> {
  List pokemonList = [];
  final List<Color> colors = List.generate(100,
      (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
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

  Future<void> fetchPokemonDetails(String url) async {
    var dio = Dio();
    try {
      var response = await dio.get(url);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(response.data['name'].toString().toUpperCase()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(response.data['sprites']['front_default']),
                Text('Height: ${response.data['height']}'),
                Text('Weight: ${response.data['weight']}'),
                Text('Base Experience: ${response.data['base_experience']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
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
        title: const Text('Pokemonlar'),
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
                  onTap: () => fetchPokemonDetails(pokemon['url']),
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
                        Divider(thickness: 2, color: Colors.black),
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
