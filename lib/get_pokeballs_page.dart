import 'package:flutter/material.dart';

class GetPokeballsPage extends StatefulWidget {
  final double money;
  
  const GetPokeballsPage({
    super.key,
    required this.money,
  });

  @override
  State<GetPokeballsPage> createState() => _GetPokeballsPageState();
}

class _GetPokeballsPageState extends State<GetPokeballsPage> {
  int _clickCount = 0;
  static const int _requiredClicks = 30;

  void _incrementCount() {
    setState(() {
      _clickCount++;
      if (_clickCount >= _requiredClicks) {
        _clickCount = 0;
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _clickCount / _requiredClicks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Pokeballs'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.catching_pokemon, color: Colors.red),
                const SizedBox(width: 5),
                Text('${widget.money}'),
              ],
            ),
          ),
        ],
      ),
      body: Container(
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
                onPressed: _incrementCount,
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
      ),
    );
  }
}
