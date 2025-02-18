@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suplements Processor'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZHAK_BookingSupp_Processor as projection on ZHAK_BookingSupp
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
    _booking,
    _Product,
    _SupplementText,
    _Travel
    
}
