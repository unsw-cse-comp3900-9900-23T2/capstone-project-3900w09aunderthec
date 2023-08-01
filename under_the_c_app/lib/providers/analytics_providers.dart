import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/analytics_request.dart';

final eventsYearlyDistributionProvider =
    FutureProvider.family<List<int>, String>(
  (ref, String uid) async {
    final content = await getEventsYearlyDistributionAPI(uid);
    return content;
  },
);
