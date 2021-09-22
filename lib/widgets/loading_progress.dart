import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("progress : onTap");
      },
      child: Container(
          color: Colors.black38,
          width:  double.infinity,
          height: 150,
          child: Center(
              child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.lightBlueAccent),
                      ),
                      height: 70,
                      width: 70,
                    ),
                  )))),
    );
  }
}