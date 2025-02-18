@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZHAK_Booking as select from /DMO/I_Booking_M
composition[0..1] of ZHAK_BookingSupp as _Supplements
association to parent ZHAK_Travel as _Travel on
$projection.travel_id = _Travel.TravelId 
association[1..1] to /DMO/I_Customer as _customer on
$projection.customer_id = _customer.CustomerID
association[1..1] to /DMO/I_Carrier as _carrier on
$projection.carrier_id = _carrier.AirlineID
association[1..1] to /DMO/I_Connection as _connections on 
$projection.connection_id = _connections.ConnectionID
association[1..1] to I_Currency as _currency on
$projection.currency_code = _currency.Currency
association[1..1] to /DMO/I_Booking_Status_VH as _BookingStatus on
$projection.booking_status = _BookingStatus.BookingStatus
association[1..1] to /DMO/I_Booking_Status_VH_Text as _BookingStatusText on
$projection.booking_status = _BookingStatusText.BookingStatus and
  _BookingStatusText.Language = 'E'
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
     @Semantics.user.lastChangedBy: true
     last_changed_at,
     /* Associations */
     _BookingStatus,
     _BookSupplement,
     _carrier,
     _Connection,
     _customer,
     _Travel,
     _connections,
     _currency,
     _BookingStatusText,    
     _Supplements
     
     
    
}
