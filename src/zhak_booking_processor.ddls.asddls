@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Processor'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZHAK_Booking_processor as projection on ZHAK_Booking
{
    key travel_id,
    key booking_id,
    booking_date,
    customer_id,
    carrier_id,
    connection_id,
    flight_date,
    @Semantics.amount.currencyCode: 'currency_code'
    flight_price,
    currency_code,
    booking_status,
    last_changed_at,
    /* Associations */
    _BookingStatus,
    _BookingStatusText,
    _BookSupplement,
    _carrier,
    _Connection,
    _connections,
    _currency,
    _customer,
    _Supplements,
    _Travel
}
