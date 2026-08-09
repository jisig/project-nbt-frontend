class ApiConstant {
  static const baseUrl = 'http://localhost:3000'; // Local Base URL
  // static const baseUrl = 'https://projectnbt.in'; // Live Base URL
  static const registerSendOtp = '/api/auth/register';
  static const registerOtpVerification = '/api/auth/verify-register-otp';
  static const loginSendOtp = '/api/auth/login';
  static const loginOtpVerification = '/api/auth/verify-login-otp';
  static const resendOtp = '/api/auth/verify-login-otp';
  static const forgotPasswordSendOtp = '/api/auth/forgot-password';
  static const forgotPasswordOtpVerification =
      '/api/auth/verify-forgot-password-otp';
  static const setNewPasswordForgotPassword = '/api/auth/reset-password';
  static const refresh = 'api/auth/refresh-token';
}
