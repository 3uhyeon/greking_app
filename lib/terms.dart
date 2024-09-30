import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white, // 배경색을 흰색으로 설정
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0, // 그림자 높이 설정
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Terms of Use\n\n',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'These Terms of Use ("Terms") govern your use of our services and the website provided by the company. By accessing or using our service, you agree to comply with and be bound by these Terms.\n\n',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  '1. User Responsibilities',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'As a user, you agree to the following responsibilities:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Ensure that your use of the service complies with all applicable laws and regulations.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Provide accurate and complete information when registering or using the service.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Avoid any activities that may disrupt the functionality or security of the service.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '2. Intellectual Property',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'All content, logos, and trademarks provided through our service are the property of the company or its licensors. You agree not to copy, distribute, or modify any content without prior written consent.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '3. Termination of Use',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The company reserves the right to terminate or suspend your access to the service at its sole discretion, with or without notice, if you violate these Terms or engage in any harmful behavior.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '4. Limitation of Liability',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The company is not responsible for any indirect, incidental, or consequential damages arising from your use or inability to use the service. The company’s liability is limited to the maximum extent permitted by law.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '5. Modifications to the Terms',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The company may modify these Terms at any time, and such modifications will be effective immediately upon posting on the website. Your continued use of the service constitutes acceptance of any changes.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    text: '6. Governing Law\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'These Terms will be governed by and construed in accordance with the laws of the country where the company is headquartered. Any disputes arising under these Terms will be subject to the exclusive jurisdiction of the courts located in that country.\n\n',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  '7. Contact Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'For any questions or concerns about these Terms, please contact us at:',
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
                              'These Terms were last updated on November 07, 2024.',
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
