import 'dart:math';
import 'package:SOAR/auth/login.dart';
import 'package:SOAR/onboarding/widgets/header.dart';
import 'package:SOAR/onboarding/widgets/next_page_button.dart';
import 'package:SOAR/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:SOAR/onboarding/widgets/ripple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'package:flutter/src/services/system_chrome.dart';

class Onboarding extends StatefulWidget {
  final double screenHeight;

  const Onboarding({
    @required this.screenHeight,
  }) : assert(screenHeight != null);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  AnimationController _cardsAnimationController;
  AnimationController _pageIndicatorAnimationController;
  AnimationController _rippleAnimationController;

  Animation<Offset> _slideAnimationLightCard;
  Animation<Offset> _slideAnimationDarkCard;
  Animation<double> _pageIndicatorAnimation;
  Animation<double> _rippleAnimation;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _cardsAnimationController = AnimationController(
      vsync: this,
      duration: kCardAnimationDuration,
    );
    _pageIndicatorAnimationController = AnimationController(
      vsync: this,
      duration: kButtonAnimationDuration,
    );
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.screenHeight,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.ease,
    ));

    _setPageIndicatorAnimation();
    _setCardsSlideOutAnimation();
  }

  @override
  void dispose() {
    _cardsAnimationController.dispose();
    _pageIndicatorAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }

  bool get isFirstPage => _currentPage == 1;

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return SlideTransition(
          position: _slideAnimationDarkCard,
          child: Column(
            children: [
              const SizedBox(height: 0),
              Image.asset("assets/slide1.png"),
              const SizedBox(height: 0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Funding",
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      color: Color(0xFF4985FD),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Assistance in finding the perfect investor for an entrepreneur.",
                  style: GoogleFonts.poppins(color: kWhite, fontSize: 15.5),
                ),
              ),
            ],
          ),
        );
      case 2:
        return SlideTransition(
          position: _slideAnimationDarkCard,
          child: Column(
            children: [
              const SizedBox(height: 00),
              Image.asset(
                "assets/slide2.png",
                scale: 1,
              ),
              const SizedBox(height: 0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "One-on-one pitches",
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      color: Color(0xFF4985FD),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 00),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Express your ideas and novelties to an investor in real time video conferencing.",
                  style: GoogleFonts.poppins(color: kWhite, fontSize: 15.5),
                ),
              ),
            ],
          ),
        );
      case 3:
        return SlideTransition(
          position: _slideAnimationDarkCard,
          child: Column(
            children: [
              const SizedBox(height: 0),
              Image.asset("assets/slide3.png"),
              const SizedBox(height: 0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Mentorship and Support",
                  style: GoogleFonts.poppins(
                      height: 1,
                      fontSize: 30,
                      color: Color(0xFF4985FD),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Our team makes sure that everyone receives guidance and support.",
                  style: GoogleFonts.poppins(color: kWhite),
                ),
              ),
            ],
          ),
        );
      default:
        throw Exception("Page with number '$_currentPage' does not exist.");
    }
  }

  void _setCardsSlideInAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset(3.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset(1.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setCardsSlideOutAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setPageIndicatorAnimation({bool isClockwiseAnimation = true}) {
    var multiplicator = isClockwiseAnimation ? 2 : -2;

    setState(() {
      _pageIndicatorAnimation = Tween(
        begin: 0.0,
        end: multiplicator * pi,
      ).animate(
        CurvedAnimation(
          parent: _pageIndicatorAnimationController,
          curve: Curves.easeIn,
        ),
      );
      _pageIndicatorAnimationController.reset();
    });
  }

  void _setNextPage(int nextPageNumber) {
    setState(() {
      _currentPage = nextPageNumber;
    });
  }

  Future<void> _nextPage() async {
    switch (_currentPage) {
      case 1:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(2);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
          _setCardsSlideOutAnimation();
          _setPageIndicatorAnimation(isClockwiseAnimation: false);
        }
        break;
      case 2:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(3);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
        }
        break;
      case 3:
        if (_pageIndicatorAnimation.status == AnimationStatus.completed) {
          await _goToLogin();
        }
        break;
    }
  }

  Future<void> _goToLogin() async {
    await _rippleAnimationController.forward();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Loginscreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(4278190106),
      systemNavigationBarIconBrightness:
          Brightness.dark, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
    setState(() {});
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Header(
                    onSkip: () async => await _goToLogin(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: _getPage(),
                ),
                AnimatedBuilder(
                  animation: _pageIndicatorAnimation,
                  child: NextPageButton(
                    onPressed: () async => await _nextPage(),
                  ),
                  builder: (_, Widget child) {
                    return OnboardingPageIndicator(
                      angle: _pageIndicatorAnimation.value,
                      currentPage: _currentPage,
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (_, Widget child) {
              return Ripple(
                radius: _rippleAnimation.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
