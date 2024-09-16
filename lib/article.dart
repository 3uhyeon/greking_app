import 'package:flutter/material.dart';

class ArticleMainPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
          children: [
            Text(
              'Train travel guide to Gangwon',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            Text(
              'How to travel to Gangwon-do by train!',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/article1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment
                  .center, // Add this line to center align the container
            ),
            SizedBox(height: 12),
            Text(
              'Gangwon-do is accessible by train through various routes. From Seoul, take the KTX to Jinbu Station, then transfer to the regional train to reach different areas of Gangwon-do...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Major train lines:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('KTX Line'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Mugunghwa Line'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('ITX-Cheongchun Line'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleMainPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incheon Airport Guide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'TO Gangwon : The complete guide !',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/article2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'From Incheon International Airport, you can easily travel to Gangwon-do. There are various options, including direct buses and trains...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Travel options:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Direct buses'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Airport limousine'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• KTX from Seoul'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleMainPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rental Guide for Gangwon',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Make sure Gangwon trip easier with rentals',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 12),
            Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/article3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Whether you need a car, a bike, or even outdoor equipment, renting is a great way to explore Gangwon-do at your own pace...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Popular rental services:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Car rentals'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Bike rentals'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Camping equipment'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleMainPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beginner Hiking Tips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Essential tips for first-time hikers in Gangwon',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 12),
            Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/article4.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Gangwon-do is famous for its beautiful mountains, and hiking is a great way to enjoy them. If you are new to hiking, here are some tips to get you started...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Beginner tips:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Wear proper hiking gear'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Stay hydrated'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('• Start with easy trails'),
            ),
          ],
        ),
      ),
    );
  }
}
