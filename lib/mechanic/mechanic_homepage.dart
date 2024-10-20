import 'package:flutter/material.dart';
class MechanicHomepage extends StatefulWidget {
  const MechanicHomepage({super.key});

  @override
  State<MechanicHomepage> createState() => _MechanicHomepageState();
}

class _MechanicHomepageState extends State<MechanicHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Mechanic',style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Text("Mechanic Homepage!"),
      )
    );
  }

}
