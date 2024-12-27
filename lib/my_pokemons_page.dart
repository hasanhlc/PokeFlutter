import 'package:flutter/material.dart';

class MyPokemonsPage extends StatelessWidget {
  final List caughtPokemons;

  const MyPokemonsPage({super.key, required this.caughtPokemons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokemons'),
        backgroundColor: Colors.blue,
      ),
      body: caughtPokemons.isEmpty
          ? const Center(
              child: Text(
                'You haven\'t caught any Pokemon yet!',
                style: TextStyle(fontSize: 18),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Image.network(
                      pokemon['sprites']['front_default'],
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    title: Text(
                      pokemon['name'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Type: ${pokemon['types'][0]['type']['name']}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
