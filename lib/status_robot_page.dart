import 'package:flutter/material.dart';

class StatusRobotPage extends StatefulWidget {
  const StatusRobotPage({Key? key}) : super(key: key);

  @override
  State<StatusRobotPage> createState() => _StatusRobotPageState();
}

class _StatusRobotPageState extends State<StatusRobotPage>
    with SingleTickerProviderStateMixin {
  bool _isRemoteCommand = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final Color blueAccent = Colors.blueAccent;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Card(
        elevation: 8,
        shadowColor: blueAccent.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: blueAccent.withOpacity(0.3),
          onTap: onPressed,
          child: Container(
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [blueAccent.withOpacity(0.8), blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Status Robot',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              // Card fix, doar textul se schimbă jos
              Card(
                elevation: 10,
                shadowColor: blueAccent.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mod de Comandă',
                        style: TextStyle(
                          color: blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          value: _isRemoteCommand,
                          activeColor: blueAccent,
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey[700],
                          onChanged: (val) {
                            setState(() {
                              _isRemoteCommand = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Doar textul este animat, nu întreg cardul
                      SizedBox(
                        height: 24,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Text(
                            _isRemoteCommand
                                ? 'Comandă de la Distanță'
                                : 'Comandă Smartphone',
                            key: ValueKey<bool>(_isRemoteCommand),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Butoane pe centrul ecranului
              Row(
                children: [
                  _buildButton('Raport Robot', () {
                    // TODO: acțiune Raport Robot
                  }),
                  const SizedBox(width: 20),
                  _buildButton('Raport Avarii', () {
                    // TODO: acțiune Raport Avarii
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
