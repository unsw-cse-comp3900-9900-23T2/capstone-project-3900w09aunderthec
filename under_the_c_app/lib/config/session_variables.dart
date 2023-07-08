class sessionVariables {
  static bool sessionIsHost = false;
  static int uid = 0;
  static String email = "";

  static void resetVariables() {
    bool sessionIsHost = false;
    int uid = 0;
    String email = "";
  }

  sessionVariables._();
}
