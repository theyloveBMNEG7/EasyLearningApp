import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingWidget extends StatefulWidget {
  final OnboardingContent content;
  final VoidCallback onNext;

  const OnboardingWidget({
    super.key,
    required this.content,
    required this.onNext,
  });

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSecondSlide = widget.content.index == 1;

    return Stack(
      children: [
        FadeTransition(
          opacity: _fadeIn,
          child: Column(
            children: [
              // Show image first unless it's slide 2
              if (!isSecondSlide)
                Expanded(
                  flex: 4,
                  child: Image.asset(widget.content.image, fit: BoxFit.contain),
                ),

              // Card section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isSecondSlide
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 60,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: widget.content.titleStart,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: widget.content.titleHighlight,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.content.subtitle,
                        style: const TextStyle(
                          color: Color.fromARGB(136, 0, 0, 0),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Show image last only for slide 2
              if (isSecondSlide)
                Expanded(
                  flex: 4, //  Increased size
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child:
                        Image.asset(widget.content.image, fit: BoxFit.contain),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
