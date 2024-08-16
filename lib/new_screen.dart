import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(3.14159), // 180 degrees in radians
        child: Container(
          decoration: BoxDecoration(
            color:Color(0xFF00968A)
          ),
          child:  Center(
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.backspace_outlined,
                      color: Colors.white,)),
                  Text(
                    'New Screen',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
