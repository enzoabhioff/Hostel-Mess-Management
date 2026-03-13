class OTPStore {
  static String? otp; // generated OTP
  static bool otpSubmitted = false; // PM entered OTP?
  static bool approved = false; // Mess Sec approved?
  static String? phone; // optional identifier

  // 🔹 Generate OTP
  static String generateOTP(String studentNumber) {
    otp = (1000 + DateTime.now().millisecond % 9000).toString();

    phone = studentNumber;
    otpSubmitted = false;
    approved = false;

    return otp!;
  }

  // 🔹 Reset all values
  static void reset() {
    otp = null;
    otpSubmitted = false;
    approved = false;
    phone = null;
  }

  // 🔹 Verify OTP entered by PM
  static bool verifyOtp(String enteredOtp) {
    if (otp != null && enteredOtp == otp && approved) {
      otpSubmitted = true;
      return true;
    }

    return false;
  }

  static bool canAccessPM() => approved && otpSubmitted;
}
