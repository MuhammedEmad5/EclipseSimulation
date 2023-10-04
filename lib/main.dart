import 'package:flutter/material.dart';

class EclipseSimulation extends StatefulWidget {
  @override
  _EclipseSimulationState createState() => _EclipseSimulationState();
}

class _EclipseSimulationState extends State<EclipseSimulation> {
  Offset moonPosition = Offset(0, 0); // Initial Moon position
  bool isEclipse = false; // Boolean to track if it's an eclipse

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eclipse Simulation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                // Update Moon's position based on user's drag gesture
                setState(() {
                  moonPosition += details.delta;
                  checkForEclipse();
                });
              },
              child: CustomPaint(
                size: Size(300, 300),
                painter: EclipsePainter(moonPosition),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEclipse ? () {} : null,
              child: Text('Button'),
              style: ElevatedButton.styleFrom(
                primary: isEclipse ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkForEclipse() {
    // Calculate whether it's an eclipse (Moon aligns with Sun)
    final sunCenter = Offset(150, 75); // Update with actual sun position
    final moonRadius = 20.0; // Radius of the Moon
    final sunRadius = 30.0; // Radius of the Sun

    final isEclipse = moonPosition.dx > sunCenter.dx - moonRadius &&
        moonPosition.dx < sunCenter.dx + moonRadius &&
        moonPosition.dy > sunCenter.dy - moonRadius &&
        moonPosition.dy < sunCenter.dy + moonRadius;

    setState(() {
      this.isEclipse = isEclipse;
    });
  }
}

class EclipsePainter extends CustomPainter {
  final Offset moonPosition;

  EclipsePainter(this.moonPosition);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Earth, Sun, and Moon here (same as before)
    final earthRadius = 50.0;
    final earthCenter = Offset(size.width / 2, size.height / 2);
    final earthPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(earthCenter, earthRadius, earthPaint);

    final sunRadius = 30.0;
    final sunCenter = Offset(150, 75); // Actual sun position
    final sunPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    final moonRadius = 20.0;
    final moonPaint = Paint()..color = Colors.grey;
    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: moonPosition, radius: moonRadius));

    // Check for eclipse (Moon aligns with Sun)
    final isEclipse = moonPosition.dx > sunCenter.dx - moonRadius &&
        moonPosition.dx < sunCenter.dx + moonRadius &&
        moonPosition.dy > sunCenter.dy - moonRadius &&
        moonPosition.dy < sunCenter.dy + moonRadius;

    // Draw Moon
    if (!isEclipse) {
      canvas.drawPath(moonPath, moonPaint);
    } else {
      // Display eclipse effect (e.g., darken the Moon)
      moonPaint.color = Colors.black.withOpacity(0.7);
      canvas.drawPath(moonPath, moonPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    home: EclipseSimulation(),
  ));
}
