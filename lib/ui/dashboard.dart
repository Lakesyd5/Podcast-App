import 'package:flutter/material.dart';
import 'package:podcast_app/ui/home_category.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(225, 29, 29, 29),
      body:  SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text('What do you want to listen to today?', style: TextStyle(color: Colors.grey.shade600, fontSize: 15),),
                const SizedBox(height: 20),
              ],
            ),

            const Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      HomeCategory(title: 'Trending Today', genre: 'Places'),
                      SizedBox(height: 10),
                      HomeCategory(title: 'Tech Podcast', genre: 'Technology'),
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
