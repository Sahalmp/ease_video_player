import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff585D67), Color(0xff233F78)]),
          ),
        ),
        title: const Text('About'),
      ),
      body: Column(children: [
        Expanded(
          flex: 8,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Image.asset(
                "asset/images/logo.png",
                width: 250,
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Text('1.0.0'))
      ]),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({Key? key}) : super(key: key);
  var privacydata = """**Privacy Policy**

Ease Video Player app is a Free app. This SERVICE is provided by Muhammed Sahal M P at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Ease Video Player unless otherwise defined in this Privacy Policy.

**Information Collection and Use**

For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.


Link to the privacy policy of third-party service providers used by the app

*   [Google Play Services](https://www.google.com/policies/privacy/)


**Security**

 We don't use your personal information. We never share any information with third party softwares or apps.


**Children’s Privacy**

 This is legal for children under 13

**Changes to This Privacy Policy**

I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2022-05-09

**Contact Us**

If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at SAHAL2050@GMAIL.COM.

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff585D67), Color(0xff233F78)]),
          ),
        ),
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Markdown(data: privacydata)),
    );
  }
}
