import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Privacy Policy\n\n',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'This Policy (the "Policy") explains the way of treatment of the information which is provided or collected in the web sites on which this Policy is posted. In addition the Policy also explains the information which is provided or collected in the course of using the applications of the Company which exist in the websites or platforms of other company.\n\n',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  '1. Information to be collected and method of collection',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Personal information items to be collected by the Company are as follows:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Information provided by the users',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(5),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Title of service',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Items to be collected (examples)',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Internet membership service'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '∘ Name, email address, ID, telephone number, address, national information, encoded identification information (CI), identification information of overlapped membership (DI)\n∘ For minors, information of legal representatives (name, birth date, CI and DI of legal representatives)'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Online payment service'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '∘ Name, address, telephone number, and email address\n∘ Payment information including account number and card number\n∘ Delivery information including delivery address, name and contact information of recipient\n∘ Information of bid, purchase and sales'),
                        ),
                      ],
                    ),
                    // Add more TableRow widgets here for additional rows.
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  '2. Use of collected information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The Company uses the collected information of users for the following purposes:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Member management and identification\n'
                  '• To detect and deter unauthorized or fraudulent use of or abuse of the Service\n'
                  '• Performance of contract, service fee payment and service fee settlement regarding provision of services demanded by the users\n'
                  '• Improvement of existing services and development of new services\n'
                  '• Making notice of function of company sites or applications or matters on policy change\n'
                  '• To help you connect with other users you already know and, with your permission, allow other users to connect with you\n'
                  '• To make statistics on member’s service usage, to provide services and place advertisements based on statistical characteristics\n'
                  '• To provide information on promotional events as well as opportunity to participate\n'
                  '• To comply with applicable laws or legal obligation',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Use of information with prior consent of the users (for example, utilization of marketing advertisement)',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'The Company agrees that it will obtain a consent from the users, if the Company desires to use the information other than those expressly stated in this Policy.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '[Option to select ‘Lawful Processing of Personal Information under GDPR’ in Appendix of Personal Privacy Policy]',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Text(
                  '3. Disclosure of collected information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Except for the following cases, the Company will not disclose personal information with a 3rd party:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• when the Company disclosing the information with its affiliates, partners and service providers;',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- When the Company\'s affiliates, partners and service providers carry out services such as bill payment, execution of orders, products delivery and dispute resolution (including disputes on payment and delivery) for and on behalf of the Company',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• when the users consent to disclose in advance;',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- when the user selects to be provided by the information of products and services of certain companies by sharing his or her personal information with those companies',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- when the user selects to allow his or her personal information to be shared with the sites or platform of other companies such as social networking sites',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- other cases where the user gives prior consent for sharing his or her personal information',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• when disclosure is required by the laws:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- if required to be disclosed by the laws and regulations; or',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '- if required to be disclosed by the investigative agencies for detecting crimes in accordance with the procedure and method as prescribed in the laws and regulations',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '4. Cookies, Beacons and Similar Technologies',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The Company may collect collective and impersonal information through \'cookies\' or \'web beacons\'.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Cookies are very small text files to be sent to the browser of the users by the server used for operation of the websites of the Company and will be stored in hard-disks of the users\' computer.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Web beacon is a small quantity of code which exists on the websites and e-mails. By using web beacons, we may know whether an user has interacted with certain webs or the contents of email.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'These functions are used for evaluating, improving services and setting-up users\' experiences so that much improved services can be provided by the Company to the users.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'The items of cookies to be collected by the Company and the purpose of such collection are as follows:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(5),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reasons for using cookies and additional information',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Strictly necessary cookies'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'This cookie is a kind of indispensable cookie for the users to use the functions of website of the Company. Unless the users allow this cookie, the services such as shopping cart or electronic bill payment cannot be provided. This cookie does not collect any information which may be used for marketing or memorizing the sites visited by the users.\n'
                              'Examples of necessary cookies:\n'
                              '∘ Memorize the information entered in an order form while searching other pages during web browser session\n'
                              '∘ For the page of products and check-out, memorize ordered services\n'
                              '∘ Check whether login is made on website\n'
                              '∘ Check whether the users are connected with correct services of the website of the Company while the Company changes the way of operating its website\n'
                              '∘ Connect the users with certain application or server of the services'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Performance cookies'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'This cookie collects information how the users use the website of the Company such as the information of the pages which are visited by the users most. This data helps the Company to optimize its website so that the users can search that website more comfortably. This cookie does not collect any information who are the users. Any and all the information collected by this cookie will be processed collectively and the anonymity will be guaranteed.\n'
                              'Examples of performance cookies:\n'
                              '∘ Web analysis: provide statistical data on the ways of using website\n'
                              '∘ Advertisement response fee: check the effect of advertisement of the Company\n'
                              '∘ Tracing affiliated companies; one of visitors of the Company provides anonymously feedback to the affiliated companies\n'
                              '∘ Management of error: measure an error which may occur so as to give a help for improving website\n'
                              '∘ Design testing: test other design of the website of Company'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Functionality cookies'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'This cookie is used for memorizing the set-ups so that the Company provides services and improves visit of users. Any information collected by this cookie do not identify the users individually.\n'
                              'Examples of functionality cookies:\n'
                              '∘ Memorize set-ups applied such as layout, text size, basic set-up and colors\n'
                              '∘ Memorize when the customer respond to a survey conducted by the Company'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('Targeting cookies or advertising cookies'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'This cookie is connected with the services provided by a 3rd party such as the buttons of \'good\' and \'share\'. The 3rd party provides these services by recognizing that the users visits the website of the Company.\n'
                              'Examples of targeting cookies or advertising cookies:\n'
                              '∘ Carry out PR to the users as targets in other websites by connecting through social networks and these networks use the information of users\' visit\n'
                              '∘ Provide the information of users\' visit to ad agencies so that they can suggest an ad which may attract the interest of the users'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'The users have an option for cookie installation. So, they may either allow all cookies by setting option in web browser, make each cookie checked whenever it is saved, or refuse all cookies to be saved: Provided that, if the user rejects the installation of cookies, it may be difficult for that user to use the parts of services provided by the Company.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  '5. User’s right',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'The users or their legal representatives, as main agents of the information, may exercise the following rights regarding the collection, use and sharing of personal information by the Company:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• exercise right to access to personal information;',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• make corrections or deletion;',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• make temporary suspension of treatment of personal information; or',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '• request the withdrawal of their consent provided before.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'If, in order to exercise the above rights, you, as an user, use the menu of \'amendment of member information of webpage or contact the Company by sending a document or e-mails, or using telephone to the company(or person in charge of management of personal information or a deputy), the Company will take measures without delay: Provided that the Company may reject the request of you only to the extent that there exists either proper cause as prescribed in the laws or equivalent cause.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '[Option to select \'User’s right when applying GDPR\' in Appendix of Personal Privacy Policy]',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    text: '6. Security\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'The Company regards the security of personal information of users as very important. The company constructs the following security measures to protect the users\' personal information from any unauthorized access, release, use or modification:\n\n',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Encryption of personal information',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '- Transmit users\' personal information by using encrypted communication zone\n- Store important information such as passwords after encrypting it',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Countermeasures against hacking',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '- Install a system in the zone the external access to which is controlled so as to prevent leakage or damage of users\' personal information by hacking or computer virus',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Establish and execute internal management plan',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Install and operate access control system',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  '• Take measures to prevent forging or alteration of access record',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),

// 7. Modification of Privacy Protection Policy
                RichText(
                  text: TextSpan(
                    text: '7. Modification of Privacy Protection Policy\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'The Company has the right to amend or modify this Policy from time to time and, in such case, the Company will make a public notice of it through bulletin board of its website (or through individual notice such as written document, fax or e-mail) and obtain consent from the users if required by relevant laws.\n\n',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

// 8. Others
                RichText(
                  text: TextSpan(
                    text: '8. Others\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            '[Option to select "data transfer to other countries" in Appendix of Personal Privacy Policy]\n'
                            '[Option to select "sites and service of 3rd party" in Appendix of Personal Privacy Policy]\n'
                            '[Option to select "guidelines for residents in California" in Appendix of Personal Privacy Policy]\n'
                            '[Option to select "guidelines for residents in Korea" in Appendix of Personal Privacy Policy]\n\n',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

// 9. Contact information of Company
                RichText(
                  text: TextSpan(
                    text: '9. Contact information of Company\n\n',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            'Please use one of the following methods to contact the Company should you have any queries in respect to this policy or wish to update your information:\n\n',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      TextSpan(
                        text:
                            '• Service name: Greking\n• E-mail: devpt@naver.com\n\n'
                            '(Add the following if designated of data protection officer)\n'
                            'The Company designates the following Data Protection Officer (DPO) in order to protect personal information of customers and deal with complaints from customers.\n\n'
                            'DPO of the Company\n'
                            'Tel.: 82+01053975652\n'
                            'E-mail: devpt@naver.com\n\n'
                            '(Add the following if the controller operating outside of the EU designates its deputy in the EU)\n'
                            'The Company designates a deputy in the EU in order to protect personal information of customers and deal with complaints from customers.\n\n'
                            'The latest update date: November 07, 2024',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                // Add more sections as needed.
              ],
            ),
          ),
        ),
        // 6. Security
      ),
    );
  }
}
