import 'package:flutter/material.dart';

class QuestionBlock extends StatefulWidget {
  final String Question;
  final String number;
  final Color block_color;
  final Color text_color;
  const QuestionBlock({super.key,required this.number, required this.Question,required this.block_color,required this.text_color});

  @override
  State<QuestionBlock> createState() => _QuestionBlockState();
}

class _QuestionBlockState extends State<QuestionBlock> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: (MediaQuery.of(context).size.height/2.5)/6,
        width: MediaQuery.of(context).size.width-100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.block_color,
            border: Border.all(
                color: Colors.white,
                width: .5
            )
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width-120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${widget.number} ${widget.Question}",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: widget.text_color
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
