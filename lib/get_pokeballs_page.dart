import 'package:flutter/material.dart';

class GetPokeballsPage extends StatefulWidget {
  final double money;
  final Function(double) onMoneyChanged;
  
  const GetPokeballsPage({
    super.key,
    required this.money,
    required this.onMoneyChanged,
  });

  @override
  State<GetPokeballsPage> createState() => _GetPokeballsPageState();
}

class _GetPokeballsPageState extends State<GetPokeballsPage> {
  int _clickCount = 0;
  static const int _requiredClicks = 30;
  int _collectedBalls = 0;

  void _incrementCount() {
    setState(() {
      _clickCount++;
      if (_clickCount >= _requiredClicks) {
        _clickCount = 0;
        _collectedBalls++;
        // Para miktarını callback ile güncelleyelim
        widget.onMoneyChanged(widget.money + 1);
      }
    });
  }

  String _getBallImage() {
    if (_collectedBalls == 0) {
      return 'assets/EmptyBucket.png';
    } else if (_collectedBalls == 1) {
      return 'assets/OneBall.png';
    } else if (_collectedBalls == 2) {
      return 'assets/TwoBall.png';
    } else {
      return 'assets/threeball.png';
    }
  }

  @override
  void dispose() {
    _clickCount = 0;
    _collectedBalls = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _clickCount / _requiredClicks;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Get Pokeballs !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Stack(
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
                  GestureDetector(
                    onTap: _incrementCount,
                    child: Image.asset(
                      'assets/Pokeball.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _getBallImage(),
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '+ $_collectedBalls',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
