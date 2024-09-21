import 'package:flutter/material.dart';

class ArticleMainPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KTX Usage Guide for Foreigners'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete Guide to Using KTX for Foreigners',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            Text(
              'Start Your Convenient and Fast Trip Across Korea',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/article1.png'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '1. How to Book KTX Tickets for Foreigners',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'The first step to riding the KTX is booking your ticket. In Korea, you can purchase tickets at the station or online. For foreigners, online booking is particularly useful, and there are various discounts available.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1-1. Booking Through the KORAIL Website',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'KORAIL is the official website of the Korean Railroad Corporation. You can access KORAIL’s official website and choose from various languages such as English, making it easy for foreign users to navigate.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Access the website and choose your language.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Sign up or log in to book your tickets.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Choose departure, destination, and travel date.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Select your train and seat, then complete payment.'),
            ),
            SizedBox(height: 20),
            Text(
              '1-2. Booking Using the KorailTalk App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'KorailTalk is a mobile app that makes booking KTX tickets easy. It supports multiple languages and allows real-time seat checks and bookings.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Download and install the KorailTalk app.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Sign up or log in and enter your trip details.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Choose your train and seat, then make payment.'),
            ),
            SizedBox(height: 20),
            Text(
              '1-3. Special Discount Tickets for Foreigners (Korail Pass)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'The Korail Pass allows unlimited use of all trains, including the KTX, for a set period. It’s available for 1, 3, and 5 days.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Purchase online and receive a voucher via email.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Exchange the voucher for a physical pass at a station.'),
            ),
            Center(
              child: Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/korailpass.png'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '2. Using QR Codes for Ticket Reservations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'KTX has adopted QR code-based smart ticketing. After booking, you will receive an e-ticket with a QR code, which you can use to board the train without needing a paper ticket.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2-1. How to Get a QR Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Once you’ve booked your KTX ticket online or through the app, your e-ticket with a QR code will be sent to you. There’s no need to print it.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2-2. How to Use the QR Code for Ticket Scanning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Scan the QR code at automatic ticket gates or with staff scanners on the train. No need for a physical ticket or ID.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Save time by boarding directly.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('No risk of losing tickets, it’s all digital.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Eco-friendly as it reduces paper waste.'),
            ),
            SizedBox(height: 30),
            Text(
              '3. How to Board the KTX at Seoul Station',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Seoul Station is a major departure point for KTX trains. It’s well-connected and easy to navigate for foreign travelers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3-1. How to Get to Seoul Station',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Seoul Station is connected by Metro Lines 1 and 4, Airport Railroad, and the Gyeongui-Jungang Line. The Airport Railroad directly connects Incheon Airport to Seoul Station.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Use Metro Lines or Airport Railroad to reach Seoul Station.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Buses and taxis also provide easy access.'),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/ktxticket.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '3-2. Boarding the KTX at Seoul Station',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Follow the signs for “KTX,” purchase tickets at the counters if necessary, and head to the designated platform.',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Follow “KTX” signs in both Korean and English.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'If you haven’t booked online, purchase tickets at the station.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title:
                  Text('Scan QR code at the gates or show it to train staff.'),
            ),
            SizedBox(height: 30),
            Text(
              '3-3. Amenities at Seoul Station',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Seoul Station has cafes, restaurants, and convenience stores. Nearby is Lotte Mart for last-minute shopping needs.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////////////
////////////////////////////1st Article//////////////////////////////////////

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
            Center(
              child: Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/article2.png'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Text(
              'From Incheon International Airport, you can easily travel to Gangwon-do. There are various options available for transportation, including direct buses, airport limousines, and KTX trains. Direct buses provide a convenient and affordable way to reach Gangwon-do from the airport. Airport limousines offer a comfortable and hassle-free journey with direct routes to popular destinations in Gangwon-do. If you prefer a faster option, you can take the KTX train from Seoul to Gangwon-do. With these transportation options, you can explore Gangwon-do conveniently and enjoy your trip!',
              style: TextStyle(fontSize: 16),
            ),
            // Section 1 - Airport Railroad
            SizedBox(height: 16),
            Text(
              '1. How to Take the Airport Railroad at Incheon Airport',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The Airport Railroad (AREX) is a fast and convenient way to travel from Incheon Airport to Seoul Station. There are two types of trains: the Express Train and the All-stop Train. The Express Train travels non-stop to Seoul Station, while the All-stop Train stops at major stations along the way.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Section 2 - Capsule Hotel Darakhyu
            Text(
              '2. Capsule Hotel Darakhyu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Darakhyu is a capsule hotel located in Incheon Airport, providing a quiet and comfortable space for travelers to rest for a few hours or overnight. It is popular for long layovers or pre/post-flight rest.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/darak1.gif'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Capsule Hotel Pricing Table
            Text(
              'Darakhyu Pricing Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Type',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Single',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Single + Shower',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Double',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Double + Shower',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Day Use (08:00 ~ 20:00, 3 hours)'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 27,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 32,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 35,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 41,000'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Overnight (20:00 ~ 08:00, 12 hours)'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 62,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 72,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 78,000'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 84,000'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Extra Hour (Per hour)'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 7,000'),
                    ),
                    Text(''),
                    Text(''),
                    Text(''),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Darakhyu Contact Info
            Text(
              'Darakhyu Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Darakhyu Terminal 1: +82-32-743-5000'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Darakhyu Terminal 2: +82-32-743-5100'),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/darak2.jpg'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Section 3 - Spa On Air
            Text(
              '3. How to Use Spa On Air',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Spa On Air is a Korean-style sauna located in Incheon Airport, offering relaxation services like saunas, jjimjilbang rooms, and massages. It’s perfect for travelers who want to unwind before or after a long flight.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Spa On Air Pricing Table
            Text(
              'Spa On Air Pricing Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Service',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Basic Fee (Up to 3 days, 4 nights)'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 10,000'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Additional Day'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('KRW 2,500'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/spa.jpg'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Spa On Air Contact Info
            Text(
              'Spa On Air Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+82-32-743-7042'),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////
////////////////////////////2st Article//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

// class ArticleMainPage3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Rental Guide for Gangwon',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Make sure Gangwon trip easier with rentals',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
//             ),
//             SizedBox(height: 12),
//             Container(
//               height: 200,
//               width: 330,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 image: DecorationImage(
//                   image: AssetImage('assets/article3.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Text(
//               'Whether you need a car, a bike, or even outdoor equipment, renting is a great way to explore Gangwon-do at your own pace. It gives you the flexibility to visit various attractions and destinations without relying on public transportation schedules. Car rentals are popular among tourists who want to have the freedom to travel to remote areas and explore hidden gems. Bike rentals are a convenient option for exploring cities and scenic routes. If you\'re planning a camping trip, renting camping equipment can save you the hassle of bringing your own gear. With rental services available in Gangwon-do, you can make the most of your trip and create unforgettable memories.',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Popular rental services:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ListTile(
//               leading: Icon(Icons.check),
//               title: Text('• Car rentals'),
//             ),
//             ListTile(
//               leading: Icon(Icons.check),
//               title: Text('• Bike rentals'),
//             ),
//             ListTile(
//               leading: Icon(Icons.check),
//               title: Text('• Camping equipment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////////////////////////////////////////////////
////////////////////////////3st Article//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

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
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/article4.png'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Section 1 - Hypothermia
            Text(
              '1. Beware of Hypothermia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'One of the most common risks while hiking is hypothermia. Hypothermia occurs when your body temperature drops rapidly and can no longer function properly, leading to very dangerous situations. It usually happens in cold or wet environments, and the risk is higher in mountainous areas where temperature changes can be sudden.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Subsection - Causes of Hypothermia
            Text(
              'Causes of Hypothermia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.circle, size: 10),
              title: Text(
                  'Temperature changes: As altitude increases, the temperature drops.'),
            ),
            ListTile(
              leading: Icon(Icons.circle, size: 10),
              title: Text(
                  'Wet clothes: If your clothes are wet from sweat or rain, they accelerate heat loss.'),
            ),
            ListTile(
              leading: Icon(Icons.circle, size: 10),
              title: Text(
                  'Wind: Wind can lower your body temperature faster by removing heat from the skin.'),
            ),
            SizedBox(height: 8),

            // Subsection - How to Prevent Hypothermia
            Text(
              'How to Prevent Hypothermia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Proper clothing: Layering is key. Start with moisture-wicking base layers.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Immediate response: If the weather turns cold or rainy, wear warmer clothing.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Warm drinks: Bring hot tea or coffee on your hike to help maintain body temperature.'),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/hiking.jpg'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Section 2 - Avoid Getting Lost
            Text(
              '2. Be Careful Not to Lose Your Way',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Getting lost while hiking is more common than you might think. In unfamiliar mountains, it’s easy to lose your sense of direction, and if you take the wrong path, it can be difficult to call for help. Careful planning and staying alert can help prevent this situation.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Subsection - Tips to Avoid Getting Lost
            Text(
              'Tips to Avoid Getting Lost',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Carry trail maps and GPS devices to track your position.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Follow trail signs and avoid unmarked paths.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Hike with companions to reduce the risk of getting lost.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Stick to your schedule and descend before it gets dark.'),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/rain.jpg'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Section 3 - Beware of Streams and Rapids
            Text(
              '3. Be Careful of Streams and Strong Currents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'When hiking, crossing streams or rivers can be dangerous, especially during or after rain when water levels rise and currents become stronger. Even a small stream can turn into a hazardous crossing if not approached with caution.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Subsection - How to Safely Cross Streams
            Text(
              'How to Cross Streams and Rapids Safely',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Find shallow spots where the water is less deep and the current is weaker.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Use rocks to cross but step carefully on non-slippery surfaces.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title:
                  Text('Use trekking poles to maintain balance in the water.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Avoid crossing fast-moving water, and turn back if necessary.'),
            ),
            SizedBox(height: 16),

            // Section 4 - Wet Rocks and Tree Roots
            Text(
              '4. Watch Out for Wet Rocks and Tree Roots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Wet rocks and tree roots on the trail can be extremely slippery, causing hikers to slip and fall. Rain or dew can make surfaces slick and reduce friction. This is particularly dangerous on steep slopes, where a slip could lead to serious injury.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Subsection - Safely Cross Wet Terrain
            Text(
              'How to Safely Cross Wet Rocks and Tree Roots',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Move slowly and carefully when crossing wet rocks or tree roots.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Wear shoes with good traction to prevent slipping.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Use your hands to hold onto nearby trees or rocks for support.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'Use trekking poles to test surfaces and maintain balance.'),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/tree.jpg'), // Image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Section 5 - Pack the Right Gear
            Text(
              '5. Pack the Right Gear',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'A successful and safe hike starts with thorough preparation. Without the right equipment, food, or clothing, you may find it difficult to handle unexpected situations. Proper preparation is the foundation of a safe hike.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Subsection - Essential Hiking Gear Checklist
            Text(
              'Essential Hiking Gear Checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Sturdy hiking boots with good support and grip.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Waterproof jacket to protect you from sudden rain.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title:
                  Text('Energy-boosting snacks and enough water for the hike.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                  'A first-aid kit with bandages and muscle relief ointments.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Smartphone and portable charger for emergencies.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Trekking poles for balance and knee support.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Map and compass in case electronic devices fail.'),
            ),
            SizedBox(height: 16),

            // Conclusion
            Text(
              'Conclusion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Hiking is one of the best ways to enjoy nature while staying healthy. However, the natural environment can pose risks that should not be overlooked. Protect yourself from hypothermia by dressing warmly, stay on track with careful planning, cross streams cautiously, be mindful of wet rocks and tree roots, and always pack the right gear. By following this guide, you can enjoy a safe and fulfilling hiking experience in nature.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
