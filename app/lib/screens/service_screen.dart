import 'package:flutter/material.dart';
import '../main.dart';
import 'doctors_screen.dart';

class ServiceScreen extends StatelessWidget {
  final String specialization;
  const ServiceScreen({super.key, required this.specialization});

  Widget _card(BuildContext c, IconData icon, String title, String sub, String type) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => DoctorsScreen(specialization: specialization, serviceType: type))),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(width: 18),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Colors.white70)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(specialization)),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            _card(context, Icons.calendar_month, 'Appointment', 'Book a physical checkup at the hospital', 'Appointment'),
            const SizedBox(height: 20),
            _card(context, Icons.video_call, 'Consultation / Mashwra', 'Get online medical advice', 'Consultation'),
          ]),
        ),
      );
}
