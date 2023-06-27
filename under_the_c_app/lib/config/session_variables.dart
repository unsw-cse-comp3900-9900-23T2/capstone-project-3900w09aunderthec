class sessionVariables {
  static bool sessionIsHost = false;
  static int uid = 0;

  static void resetVariables() {
    bool sessionIsHost = false;
    int uid = 0;
  }

  sessionVariables._();
}
