@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZHAK_Travel_Processor as projection on ZHAK_Travel
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Agency',
      entity.element: 'AGENCYID'
     }]  
    AgencyId,
//    @Semantics.text: true
    _agency.Name as AgencyName,
    CustomerId,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'   
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _agency,
    _currency,
    _customer,
    _overall_status_text,
    _overall_status_vh
}
