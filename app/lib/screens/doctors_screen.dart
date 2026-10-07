import 'package:flutter/material.dart';
import '../api.dart';
import '../main.dart';

class DoctorsScreen extends StatelessWidget {
  final String specialization, serviceType; // serviceType: 'Appointment' | 'Consultation'
  const DoctorsScreen({super.key, required this.specialization, required this.serviceType});

  bool get _isAppt => serviceType == 'Appointment';

  Future<void> _confirm(BuildContext context, Doctor d) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(_isAppt ? 'Confirm appointment' : 'Confirm consultation'),
        content: Text('${_isAppt ? 'Book an appointment' : 'Request a consultation'} with ${d.name} ($specialization)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await Api.book(specialization, d.id, serviceType);
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: kRed, size: 48),
          title: const Text('Request sent'),
          content: Text('Your ${_isAppt ? 'appointment' : 'consultation'} with ${d.name} was sent to the hospital.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(specialization)),
        body: FutureBuilder<List<Doctor>>(
          future: Api.doctors(specialization),
          builder: (context, s) {
            if (s.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator(color: kRed));
            if (s.hasError) return Center(child: Text('${s.error}'));
            final docs = s.data!;
            if (docs.isEmpty) return const Center(child: Text('No doctors available yet'));
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final d = docs[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kRed.withOpacity(.25))),
                  child: Column(children: [
                    Row(children: [
                      CircleAvatar(radius: 34, backgroundColor: kRed.withOpacity(.1), backgroundImage: NetworkImage(d.image), onBackgroundImageError: (_, __) {}),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(d.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.access_time, size: 16, color: kRed),
                            const SizedBox(width: 4),
                            Expanded(child: Text(d.timings, style: const TextStyle(color: Colors.black54))),
                          ]),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => _confirm(context, d), child: Text(_isAppt ? 'Appointment' : 'Consult / Mashwra')),
                  ]),
                );
              },
            );
          },
        ),
      );
}
