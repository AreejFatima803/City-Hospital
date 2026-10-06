import 'package:flutter/material.dart';
import '../api.dart';
import '../main.dart';
import 'login_screen.dart';
import 'service_screen.dart';

const specializations = [
  'General Physicians', 'General Surgeon', 'Gynaecologist', 'Gastroenterologist', 'Orthopedics',
  'Paediatrician', 'Paediatric Surgeons', 'Paediatric Nephrologist', 'Paediatric Cardiologist', 'E.N.T',
  'Ophthalmologist', 'Cardiologist', 'Nephrologist', 'Neuro Surgeon', 'Neurologist', 'Anesthesia',
  'Pathologist', 'Pulmonologist', 'Cosmetic Surgeon', 'Radiologist', 'Urologist',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('City Hospital'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () async {
                await Api.logout();
                if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Align(alignment: Alignment.centerLeft, child: Text('Choose a specialization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.15),
              itemCount: specializations.length,
              itemBuilder: (_, i) => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceScreen(specialization: specializations[i]))),
                child: Ink(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kRed.withOpacity(.25))),
                  padding: const EdgeInsets.all(10),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.medical_services_outlined, color: kRed, size: 34),
                    const SizedBox(height: 8),
                    Text(specializations[i], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      );
}
