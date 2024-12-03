import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimationDemo(),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<Offset> _moveAnimation;
  late Animation<Offset> _slideAnimation;

  String _currentAnimation = ""; // To track the current animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define each animation with its behavior
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _blinkAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(100, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -50),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation(String type) async {
    // Set the current animation type
    setState(() {
      _currentAnimation = type;
    });

    _controller.reset();

    if (type == "Blink") {
      // Special case for blinking
      _controller.repeat(
          reverse: true, period: const Duration(milliseconds: 500));
      await Future.delayed(const Duration(seconds: 5));
      _controller.stop();
    } else {
      // Forward and reverse for other animations
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Android Animation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              Widget animatedWidget = child!;

              // Apply animation based on the selected type
              switch (_currentAnimation) {
                case 'Clockwise':
                  animatedWidget = Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: animatedWidget,
                  );
                  break;
                case 'Zoom':
                  animatedWidget = Transform.scale(
                    scale: _scaleAnimation.value,
                    child: animatedWidget,
                  );
                  break;
                case 'Fade':
                  animatedWidget = Opacity(
                    opacity: _fadeAnimation.value,
                    child: animatedWidget,
                  );
                  break;
                case 'Blink':
                  animatedWidget = Opacity(
                    opacity: _blinkAnimation.value,
                    child: animatedWidget,
                  );
                  break;
                case 'Move':
                  animatedWidget = Transform.translate(
                    offset: _moveAnimation.value,
                    child: animatedWidget,
                  );
                  break;
                case 'Slide':
                  animatedWidget = Transform.translate(
                    offset: _slideAnimation.value,
                    child: animatedWidget,
                  );
                  break;
              }

              return animatedWidget;
            },
            child: Image.asset(
              'assets/images/university image.jpg',
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildAnimationButton('Zoom', () {
                _playAnimation('Zoom');
              }),
              _buildAnimationButton('Clockwise', () {
                _playAnimation('Clockwise');
              }),
              _buildAnimationButton('Fade', () {
                _playAnimation('Fade');
              }),
              _buildAnimationButton('Blink', () {
                _playAnimation('Blink');
              }),
              _buildAnimationButton('Move', () {
                _playAnimation('Move');
              }),
              _buildAnimationButton('Slide', () {
                _playAnimation('Slide');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
