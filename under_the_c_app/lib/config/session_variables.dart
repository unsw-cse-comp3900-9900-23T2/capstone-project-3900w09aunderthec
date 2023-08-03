// class used to store frequently used user data
class sessionVariables {
  static bool sessionIsHost = false;
  static int uid = 1; //for testing purpose
  static String email = "";
  static int vipLevel = 0;
  static int loyaltyPoints = 0;
  static int navLocation = 1;

  static void resetVariables() {
    sessionIsHost = true;
    uid = 0;
    email = "";
    vipLevel = 0;
    loyaltyPoints = 0;
    navLocation = 1;
  }

  sessionVariables._();
}
