String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  final email = value.trim().toLowerCase();

  // Basic email pattern with common domains
  final basicPattern =
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu|gov|mil|io|co|cm|info)$";
  final regex = RegExp(basicPattern);

  // Block common problematic prefixes or banned terms
  final blockedPatterns = [
    RegExp(r'^sa@'),
    RegExp(r'^admin@'),
    RegExp(r'^test@'),
    RegExp(r'^example@'),
    RegExp(r'^noreply@'),
    RegExp(r'^null@'),
    RegExp(r'^invalid@'),
  ];

  // Allowlist specific domains (optional, for strict control)
  final allowedDomains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'student.edu.cm'
  ];

  if (!regex.hasMatch(email)) {
    return 'Enter a valid email address';
  }

  if (blockedPatterns.any((pattern) => pattern.hasMatch(email))) {
    return 'This email address is not allowed';
  }

  // Optional strict domain filtering
  final domain = email.split('@').last;
  if (!allowedDomains.contains(domain)) {
    return 'Only emails from approved domains are allowed';
  }

  return null;
}
