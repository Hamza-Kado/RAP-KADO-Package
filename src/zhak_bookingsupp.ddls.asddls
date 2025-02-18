@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suplements View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZHAK_BookingSupp as select from /dmo/booksuppl_m
association to parent ZHAK_Booking as _booking on
$projection.BookingId = _booking.booking_id and
$projection.TravelId  = _booking.travel_id
association[1..1] to ZHAK_Travel as _Travel on 
$projection.TravelId = _Travel.TravelId
//association[1..1] to ZHAK_Booking as _Booking on
//$projection.BookingId = _Booking.booking_id
association[1..1] to /DMO/I_Supplement as _Product on
$projection.SupplementId = _Product.SupplementID
association[1..1] to /DMO/I_SupplementText as _SupplementText on
$projection.SupplementId = _SupplementText.SupplementID and
_SupplementText.LanguageCode = 'E'
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    @Semantics.user.lastChangedBy: true
    last_changed_at as LastChangedAt,
    _Travel,
    _booking,
    _Product,
    _SupplementText
}
