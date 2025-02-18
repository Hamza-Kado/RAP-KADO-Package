@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Prosessor Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_HA_BOOKSUPPL_PROSESSOR as projection on ZATS_HA_BOOKSUPPL
{
   key TravelId,
   key BookingId,
   key BookingSupplementId,
   SupplementId,
   @Semantics.amount.currencyCode: 'CurrencyCode'
   Price,
   CurrencyCode,
   LastChangedAt,
   /* Associations */
   _Booking : redirected to parent ZATS_HA_BOOKING_PROSESSOR,
   _Product,
   _SupplementText,
   _Travel : redirected to zats_ha_travel_prosessor 
}
