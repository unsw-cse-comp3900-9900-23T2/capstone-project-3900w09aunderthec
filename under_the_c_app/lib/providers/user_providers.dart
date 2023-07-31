import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../api/user_request.dart';
import '../types/users/customer_type.dart';

final hostUidProvider = StateProvider<String>((ref) => "");

class UserStateNotifier extends StateNotifier<Customer?> {
  UserStateNotifier() : super(null) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    state = await getCustomerById(sessionVariables.uid.toString());
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, Customer?>(
    (ref) => UserStateNotifier());
