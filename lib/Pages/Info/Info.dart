import 'package:flutter/material.dart';
import 'artist_details_page.dart';
import 'models.dart';
import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
import  '../Login/login_page.dart';

class Info extends StatelessWidget {
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  // bool _canCheckBiometric = false;
  // String _authorizedOrNot ="Not Authorized";
  // List<BiometricType> _avalableBiometricTypes = List<BiometricType>();
  static final Artist andy = Artist(
    firstName: 'Student',
    lastName: '   UBB',
    avatar: 'assets/avatar.png',
    backdropPhoto: 'assets/backdrop.png',
    location: 'CLUJ-NAPOCA, Romania',
    biography: '''    Adresă: Strada Universității 7-9
      Zip: 400084
    Rector: Ioan-Aurel Pop''',
    videos: <Video>[
      Video(
        title: 'Welcome to UBB!',
        thumbnail: 'assets/video1_thumb.png',
        url: 'https://www.youtube.com/watch?v=t4TATwGZHjM',
      ),
      Video(
        title: 'Universitatea Babeș-Bolyai, Cluj-Napoca',
        thumbnail: 'assets/video2_thumb.png',
        url: 'https://www.youtube.com/watch?v=43kLbie-_OU',
      ),
      Video(
        title: 'Facultatea de Matematică şi Informatică, Universitatea Babeş-Bolyai',
        thumbnail: 'assets/video3_thumb.png',
        url: 'https://www.youtube.com/watch?list=PLR63lQ_rqQ02P5KC4fc2gaYj9FVdoZO8z&v=ZU8XxwLL26o',
      ),
      Video(
        title: 'Filmul de prezentare a Clujului ',
        thumbnail: 'assets/video4_thumb.png',
        url: 'https://www.youtube.com/watch?v=Er9rAvnPG6o',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArtistDetailsPage(andy),
    );
  }
}
