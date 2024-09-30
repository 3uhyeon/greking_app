import 'package:flutter/material.dart';

class LocationInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Location Information Policy\n\n',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'This Location Information Policy ("Policy") describes how we collect, use, and share your location information when you use our services. By using our services, you agree to the terms described in this Policy.\n\n',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  '1. Collection of Location Data',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'We may collect your location data in the following ways:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Through GPS and other location-based technologies integrated into your device.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• By obtaining location data from your mobile network or Wi-Fi access points.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '2. Use of Location Data',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Your location data may be used for the following purposes:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• To provide location-based services, such as nearby product suggestions or tracking services.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• To enhance user experience by improving the accuracy and relevance of the service.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '3. Sharing of Location Data',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'We may share your location data with third parties in the following circumstances:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• With trusted partners to provide location-based services, with your consent.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• When required by law or to comply with legal processes.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '4. Managing Your Location Preferences',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'You can manage your location preferences in the following ways:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• By adjusting your device’s location settings to enable or disable location sharing.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• By reviewing and changing the permissions granted to specific apps in your device settings.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '5. Retention of Location Data',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'We will retain your location data for as long as it is necessary to provide our services or as required by law.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    text: '6. Security of Location Data\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'We implement appropriate technical and organizational measures to protect your location data from unauthorized access or disclosure.\n\n',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  '7. Changes to this Policy',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'We may update this Policy from time to time. Any changes will be posted on our website and will become effective upon posting.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '8. Contact Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'If you have any questions or concerns about this Policy, please contact us at:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text:
                              '• Company: Greking\n• Email: devpt@naver.com\n\n'),
                      TextSpan(
                          text:
                              'This Policy was last updated on November 07, 2024.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
