class ExceptionHandling implements Exception {
  String message;

  ExceptionHandling({required this.message});

  @override
  String toString() {
    if (message.contains('phone auth credential is invalid')) {
      return 'OTP is incorrect! Please try again.';
    } else if (message
        .contains('format of the phone number provided is incorrect')) {
      return 'Invalid phone number!';
    }
    return 'Something went wrong!';
  }
}
