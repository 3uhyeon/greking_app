import 'package:flutter/material.dart';

class ArticleMainPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
            SizedBox(height: 30),
            Text(
              'Gangwon-do is accessible by train through various routes. From Seoul, take the KTX to Jinbu Station, then transfer to the regional train to reach different areas of Gangwon-do. Another option is to take the Mugunghwa Line directly from Seoul to Gangneung, which is a popular destination in Gangwon-do known for its beautiful beaches and vibrant city life. Additionally, the ITX-Cheongchun Line offers a convenient way to travel from Chuncheon to Gangneung, passing through scenic landscapes and charming towns along the way. With these train options, exploring Gangwon-do has never been easier!',
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
      body: SingleChildScrollView(
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
            SizedBox(height: 30),
            Text(
              'From Incheon International Airport, you can easily travel to Gangwon-do. There are various options available for transportation, including direct buses, airport limousines, and KTX trains. Direct buses provide a convenient and affordable way to reach Gangwon-do from the airport. Airport limousines offer a comfortable and hassle-free journey with direct routes to popular destinations in Gangwon-do. If you prefer a faster option, you can take the KTX train from Seoul to Gangwon-do. With these transportation options, you can explore Gangwon-do conveniently and enjoy your trip!',
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
      body: SingleChildScrollView(
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
            SizedBox(height: 30),
            Text(
              'Whether you need a car, a bike, or even outdoor equipment, renting is a great way to explore Gangwon-do at your own pace. It gives you the flexibility to visit various attractions and destinations without relying on public transportation schedules. Car rentals are popular among tourists who want to have the freedom to travel to remote areas and explore hidden gems. Bike rentals are a convenient option for exploring cities and scenic routes. If you\'re planning a camping trip, renting camping equipment can save you the hassle of bringing your own gear. With rental services available in Gangwon-do, you can make the most of your trip and create unforgettable memories.',
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
      body: SingleChildScrollView(
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
            SizedBox(height: 30),
            Text(
              'Gangwon-do is renowned for its breathtaking mountains, such as Seoraksan and Odaesan, which attract hikers from across Korea and beyond. '
              'For beginners, hiking in these areas can be both thrilling and challenging. To help ensure you have a safe, enjoyable experience, '
              'we\'ve compiled some key tips for those who are just starting their hiking journey in Gangwon-do:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Wear the Right Gear',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Proper hiking gear is essential for both comfort and safety. Make sure to wear sturdy hiking boots that offer good ankle support and traction, '
              'as the terrain can be rocky and uneven. Dress in moisture-wicking, breathable layers to regulate your body temperature, '
              'and always carry a rain jacket, as weather in the mountains can change rapidly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Stay Hydrated and Bring Snacks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Hiking is physically demanding, and it’s important to stay hydrated. Carry enough water for the entire hike, and don’t forget energy-boosting snacks like nuts, dried fruit, and energy bars. '
              'These will help maintain your stamina, especially on longer trails. If you’re planning a full-day hike, packing a light meal is a good idea.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Start with Easy Trails',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'It’s tempting to dive into the more famous, challenging hikes, but as a beginner, it’s best to start with shorter, easier trails. '
              'Gangwon-do has a variety of scenic routes suitable for all levels. Consider starting with gentler trails in Odaesan National Park or some of the well-marked lower paths of Seoraksan National Park. '
              'As you gain confidence, you can explore more difficult terrain.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Know Your Limits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Hiking can be physically taxing, and it’s important to listen to your body. If you start to feel fatigued, don’t hesitate to take breaks. '
              'Set a comfortable pace and allow extra time for rest stops. Remember, hiking is about the journey, not the destination, so don’t push yourself too hard, especially when you’re just beginning.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Plan Ahead and Check the Weather',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Before heading out, make sure you’re aware of the weather forecast and trail conditions. Gangwon-do’s weather can change quickly, especially in the mountains. '
              'Check trail maps and prepare for potential weather changes by packing essentials like sunscreen, extra layers, and a raincoat. Always let someone know your hiking plans and expected return time.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Hike with a Buddy or Group',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'For your first hikes, consider going with a friend or joining a hiking group. Not only is hiking with others more enjoyable, but it’s also safer. '
              'In case of emergencies or unexpected challenges, having someone with you can make a big difference. Many organized groups in Gangwon-do offer guided hikes, which can be a great way to learn from more experienced hikers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Respect Nature and Leave No Trace',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'As you enjoy the beauty of Gangwon-do’s natural environment, it’s important to respect it as well. Stick to marked trails, avoid picking plants, and don’t disturb wildlife. '
              'Always carry your trash with you and dispose of it properly. The “Leave No Trace” principle helps preserve the trails and natural habitats for future hikers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Hiking in Gangwon-do offers some of the most beautiful views in Korea. By starting with these tips, you’ll set yourself up for an enjoyable, safe, and rewarding outdoor adventure!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
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
