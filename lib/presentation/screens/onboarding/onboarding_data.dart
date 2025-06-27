class OnboardingContent {
  final int index;
  final String image;
  final String titleStart; // First part
  final String titleHighlight; // Highlighted blue part
  final String subtitle;

  OnboardingContent({
    required this.index,
    required this.image,
    required this.titleStart,
    required this.titleHighlight,
    required this.subtitle,
  });
}

final List<OnboardingContent> onboardingPages = [
  OnboardingContent(
    image: 'assets/images/onboarding1.png',
    titleStart: 'Find the right past question to \nguarantee your ',
    titleHighlight: 'success',
    subtitle:
        'With easy learning, education fits into your life—seamlessly and stress-free. Start today and unlock knowledge on your terms!',
    index: 0,
  ),
  OnboardingContent(
    image: 'assets/images/onboarding2.png',
    titleStart: 'Easy learning, when ever & \nwherever ',
    titleHighlight: 'you want',
    subtitle:
        'Easy learning, whenever & wherever you want because success starts with the right preparation!',
    index: 1,
  ),
  OnboardingContent(
    image: 'assets/images/onboarding3.png',
    titleStart: 'Start the journey to ',
    titleHighlight: '\nExcellence & Distinction',
    subtitle:
        'The difference between good and topper isn’t talent it’s strategy. Past papers + smart revision = your shortcut to the top',
    index: 2,
  ),
];
