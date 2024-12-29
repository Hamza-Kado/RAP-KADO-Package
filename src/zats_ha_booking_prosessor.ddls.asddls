@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Prosessor Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_HA_BOOKING_PROSESSOR as projection on ZATS_HA_BOOKING
{
  key TravelId,
  key BookingId,
  BookingDate,
  CustomerId,
  CarrierId,
  ConnectionId,
  FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  FlightPrice,
  CurrencyCode,
  BookingStatus,
  LastChangedAt,
  /* Associations */
  _BookingStatus,
  _BookingStatusText,
  _Carrier,
  _Connection,
  _Customer,
  _Supplements,
  _Travel : redirected to parent zats_ha_travel_prosessor
    
}
