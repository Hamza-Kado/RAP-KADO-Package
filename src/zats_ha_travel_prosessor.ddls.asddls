@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Prosessor Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zats_ha_travel_prosessor as projection on ZATS_HA_TRAVEL
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Agency',
      entity.element: 'AGENCYID'
     }] 
    AgencyId,
    @Semantics.text: true
    _Agency.Name as AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
     @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Customer',
      entity.element: 'CustomerID'
     }] 
    CustomerId,
    @Semantics.text: true
    _Customer.FirstName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'StatusText' ]
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    @Semantics.text: true
    StatusText,
    Criticality,
    /* Associations */
    _Agency,
    _Booking,
    _Currency,
    _Customer,
    _OverallStatus,
    _overallStatusText
}
