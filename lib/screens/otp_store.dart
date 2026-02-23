class OTPStore {
  static String? otp;             // generated OTP
  static bool otpSubmitted = false; // PM entered OTP?
  static bool approved = false;      // Mess Sec approved?
  static String? phone;           // optional identifier

  // Reset all values
  static void reset() {
    otp = null;
    otpSubmitted = false;
    approved = false;
    phone = null;
  }

  // Verify OTP entered by PM
  static bool verifyOtp(String enteredOtp) {
    if (otp != null && enteredOtp == otp && approved) {
      otpSubmitted = true;   // mark OTP as submitted
      return true;           // OTP valid
    }
    return false;            // OTP invalid
  }

  static bool canAccessPM() => approved && otpSubmitted;
}
