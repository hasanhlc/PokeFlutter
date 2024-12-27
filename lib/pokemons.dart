import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:math';

class PokemonsPage extends StatefulWidget {
  final double money;
  final Function(double) onMoneyChanged;
  final Function(dynamic) onPokemonCaught;

  const PokemonsPage({
    super.key,
    required this.money,
    required this.onMoneyChanged,
    required this.onPokemonCaught,
  });

  @override
  State<PokemonsPage> createState() => _PokemonsPageState();
}

class _PokemonsPageState extends State<PokemonsPage>
    with SingleTickerProviderStateMixin {
  List pokemonList = [];
  final List<Color> colors = List.generate(100,
      (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

  late AnimationController _animationController;
  late Animation<double> _animation;

  List caughtPokemons = []; // Yakalanan pokemonlar listesi

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
                    Image.network(
                      response.data['sprites']['front_default'],
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      response.data['name'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Height: ${response.data['height']} | Weight: ${response.data['weight']}',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.money >= 1.0) {
                          setState(() {
                            widget.onMoneyChanged(widget.money - 1.0);
                            widget.onPokemonCaught(response.data);
                            caughtPokemons.add(response.data);
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You caught ${response.data['name'].toString().toUpperCase()}!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not enough money!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Catch (1.0)'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return pokemonList.isEmpty
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
                onTap: () => fetchPokemonDetails(pokemon['url'], colors[index]),
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
                      Text(
                        pokemon['name'].toString().toUpperCase(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
