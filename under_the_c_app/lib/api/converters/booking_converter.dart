import '../../types/bookings/booking_type.dart';

UserBooking addBackendBooking(data) {
  return UserBooking(
    bookingId: data['booking']['id'].toString(),
    // loyaltyPoints: data['booking']['toCustomer']['loyaltyPoints'],
    // vipLevel: data['booking']['toCustomer']['vipLevel'],
    loyaltyPoints: data['newLoyaltyPoints'],
    vipLevel: data['newVipLevel'],
    refundable: false,
  );
}

UserBooking removeBackendBooking(data) {
  return UserBooking(
    bookingId: data['id'].toString(),
    loyaltyPoints: data['toCustomer']['loyaltyPoints'],
    vipLevel: data['toCustomer']['vipLevel'],
    refundable: false,
  );
}
