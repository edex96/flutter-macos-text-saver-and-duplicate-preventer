import 'package:flutter/material.dart';

snack(context, msg, {bool negative = false}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        //key: Key(Random().nextInt(20).toString()),
        backgroundColor: negative ? const Color(0xffB31312) : null,
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  });
}
