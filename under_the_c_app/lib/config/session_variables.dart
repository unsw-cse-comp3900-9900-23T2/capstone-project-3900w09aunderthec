class sessionVariables {
  static bool sessionIsHost = true;
  static int uid = 0;
  static String email = "";
  static int vipLevel = 0;
  static int loyaltyPoints = 0;

  static void resetVariables() {
    sessionIsHost = true;
    uid = 0;
    email = "";
    vipLevel = 0;
    loyaltyPoints = 0;
  }

  sessionVariables._();
}
