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
      var response = await dio.get('https://pokeapi.co/api/v2/pokemon?limit=151');
      var results = response.data['results'] as List;
      
      // Sadece temel seviye Pokemonları filtrele
      var filteredResults = results.where((pokemon) {
        // Pokemon ID'sini URL'den çıkar
        var id = int.parse(pokemon['url'].split('/')[6]);
        // Sadece 1-151 arası Pokemonları al ve evrimleşmiş formları filtrele
        return id <= 151 && !_isEvolvedForm(pokemon['name']);
      }).toList();

      setState(() {
        pokemonList = filteredResults;
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  bool _isEvolvedForm(String name) {
    // Evrimleşmiş formların listesi
    final evolvedForms = [
      // Normal evrimler
      'charmeleon', 'charizard', 'wartortle', 'blastoise',
      'metapod', 'butterfree', 'kakuna', 'beedrill',
      'pidgeotto', 'pidgeot', 'raticate', 'fearow',
      'arbok', 'raichu', 'sandslash', 'nidorina',
      'nidoqueen', 'nidorino', 'nidoking', 'clefable',
      'ninetales', 'wigglytuff', 'golbat', 'gloom',
      'vileplume', 'parasect', 'venomoth', 'dugtrio',
      'persian', 'golduck', 'primeape', 'arcanine',
      'poliwhirl', 'poliwrath', 'kadabra', 'alakazam',
      'machoke', 'machamp', 'weepinbell', 'victreebel',
      'tentacruel', 'graveler', 'golem', 'rapidash',
      'slowbro', 'magneton', 'dodrio', 'dewgong',
      'muk', 'cloyster', 'haunter', 'gengar',
      'onix', 'hypno', 'kingler', 'electrode',
      'exeggcute', 'exeggutor', 'marowak', 'hitmonlee',
      'hitmonchan', 'weezing', 'rhydon', 'chansey',
      'tangela', 'kangaskhan', 'seaking', 'starmie',
      'mr-mime', 'scyther', 'jynx', 'electabuzz',
      'magmar', 'pinsir', 'tauros', 'gyarados',
      'lapras', 'ditto', 'vaporeon', 'jolteon',
      'flareon', 'porygon', 'omastar', 'kabutops',
      'aerodactyl', 'snorlax', 'dragonair', 'dragonite',
      'ivysaur', 'venusaur', // Bulbasaur evrimi
      'charmeleon', 'charizard', // Charmander evrimi
      'wartortle', 'blastoise', // Squirtle evrimi
      'metapod', 'butterfree', // Caterpie evrimi
      'kakuna', 'beedrill', // Weedle evrimi
      'pidgeotto', 'pidgeot', // Pidgey evrimi
      'raticate', // Rattata evrimi
      'spearow', // Fearow evrimi
      'arbok', // Ekans evrimi
      'sandslash', // Sandshrew evrimi
      'nidorina', 'nidoqueen', // Nidoran♀ evrimi
      'nidorino', 'nidoking', // Nidoran♂ evrimi
      'clefable', // Clefairy evrimi
      'ninetales', // Vulpix evrimi
      'wigglytuff', // Jigglypuff evrimi
      'golbat', // Zubat evrimi
      'gloom', 'vileplume', // Oddish evrimi
      'parasect', // Paras evrimi
      'venomoth', // Venonat evrimi
      'dugtrio', // Diglett evrimi
      'persian', // Meowth evrimi
      'golduck', // Psyduck evrimi
      'primeape', // Mankey evrimi
      'arcanine', // Growlithe evrimi
      'poliwrath', 'poliwhirl', // Poliwag evrimi
      'kadabra', 'alakazam', // Abra evrimi
      'machoke', 'machamp', // Machop evrimi
      'weepinbell', 'victreebel', // Bellsprout evrimi
      'tentacruel', // Tentacool evrimi
      'graveler', 'golem', // Geodude evrimi
      'rapidash', // Ponyta evrimi
      'slowbro', // Slowpoke evrimi
      'magneton', // Magnemite evrimi
      'farfetchd', // Tek seviyeli
      'dodrio', // Doduo evrimi
      'dewgong', // Seel evrimi
      'muk', // Grimer evrimi
      'cloyster', // Shellder evrimi
      'haunter', 'gengar', // Gastly evrimi
      'hypno', // Drowzee evrimi
      'kingler', // Krabby evrimi
      'electrode', // Voltorb evrimi
      'exeggutor', // Exeggcute evrimi
      'marowak', // Cubone evrimi
      'weezing', // Koffing evrimi
      'rhydon', // Rhyhorn evrimi
      'seaking', // Goldeen evrimi
      'starmie', // Staryu evrimi
      'gyarados', // Magikarp evrimi
      'dragonair', 'dragonite', // Dratini evrimi
    ];
    return evolvedForms.contains(name.toLowerCase());
  }

  Future<void> fetchPokemonDetails(String url, Color cardColor) async {
    var dio = Dio();
    try {
      var response = await dio.get(url);
      _animationController.reset();
      _animationController.forward();

      // Pokemon'un yakalanmış olup olmadığını kontrol et
      bool isPokemonCaught = caughtPokemons.any((pokemon) => pokemon['name'] == response.data['name']);

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: ScaleTransition(
              scale: _animation,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                content: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 400,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/CardBackground.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 45),
                          Image.network(
                            response.data['sprites']['front_default'],
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            response.data['name'].toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Height: ${response.data['height']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Weight: ${response.data['weight']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: isPokemonCaught 
                                ? null 
                                : () {
                                  if (widget.money >= 2.0) {
                                    final bool catchSuccess = Random().nextBool();
                                    setState(() {
                                      widget.onMoneyChanged(widget.money - 2.0);
                                    });
                                    
                                    if (catchSuccess) {
                                      setState(() {
                                        widget.onPokemonCaught(response.data);
                                        caughtPokemons.add(response.data);
                                      });
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: AlertDialog(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: const Text(
                                                'Success!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: const Text(
                                                'Pokemon has been caught!',
                                                style: TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    foregroundColor: Colors.green,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: AlertDialog(
                                              backgroundColor: Colors.red.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: const Text(
                                                'Failed!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: const Text(
                                                'Pokemon escaped!',
                                                style: TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    foregroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.grey.shade600,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isPokemonCaught ? 'Caught' : 'Catch',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.catching_pokemon),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Cost: 2',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: pokemonList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.615, // Kartın en-boy oranını resme göre ayarladım
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                final pokemonId = pokemon['url'].toString().split('/')[6];
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
                return GestureDetector(
                  onTap: () => fetchPokemonDetails(pokemon['url'], colors[index]),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/CardBackgroundMain.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pokemon['name'].toString().toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black,
                              ),
                            ],
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
