import 'package:flutter/material.dart';
import 'package:podcast_app/ui/home_category.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      // backgroundColor: Colors.black54,
      body:  SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text('What do you want to listen to today?'),
                SizedBox(height: 20),
              ],
            ),

            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      HomeCategory(title: 'Trending Today', genre: 'Places'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'Tech Podacast', genre: 'Technology'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'Sports Today', genre: 'Sports'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'Science', genre: 'Science'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'News Flash', genre: 'News'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'Fun Time', genre: 'Leisure'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
