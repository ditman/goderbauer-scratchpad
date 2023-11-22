import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.yellow,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('I am only as big as I need to be!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ))),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in aliquam lectus. Cras nulla ligula, commodo quis mollis id, faucibus in felis. In lacinia tortor at malesuada suscipit. Sed lobortis bibendum turpis sed efficitur. Ut pulvinar orci augue. Etiam pellentesque, tortor at tristique elementum, odio odio vestibulum orci, at venenatis lacus purus eget massa. Aliquam vulputate ipsum nec arcu blandit, nec tristique nunc mollis. Nullam tempus est nec ex venenatis auctor. Cras vel sapien a massa egestas tempor dictum posuere ante.",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Text(
                "Mauris sit amet leo ultricies, eleifend tellus nec, dictum urna. Pellentesque semper malesuada nisi ut ultricies. Curabitur scelerisque molestie feugiat. Sed sagittis venenatis diam eget fermentum. Pellentesque sit amet orci vitae elit fermentum blandit id non justo. Integer ac vulputate ipsum. Cras hendrerit nunc ac sem accumsan porta. Sed blandit consequat dictum. Suspendisse vel faucibus nibh. Phasellus molestie, lorem ut rutrum rutrum, erat justo sollicitudin nulla, nec luctus magna metus sed lorem. Integer dapibus gravida enim nec dapibus. In gravida magna nec mi cursus, in feugiat libero aliquam. Quisque aliquam metus quis metus ullamcorper, sed tempus nisl rhoncus. Nulla facilisi. Donec placerat metus vitae est laoreet finibus.",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
