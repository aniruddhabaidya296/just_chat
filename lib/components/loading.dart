import 'package:flutter/material.dart';

import 'colors.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(COLORS.red),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
