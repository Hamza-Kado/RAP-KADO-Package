@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Non Analytic Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_ATS_HA_SALES_NA 
as select from ZI_ATS_HA_SALES_CUBE
  {  
    key _BusinessPartner.countryname,
    @Aggregation.default: #SUM
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @AnalyticsDetails.query.axis: #COLUMNS
    GrossAmount,
    @AnalyticsDetails.query.axis: #ROWS
    @Consumption.filter.selectionType: #SINGLE
    CurrencyCode,
    @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
    @AnalyticsDetails.query.axis: #COLUMNS
    Quantity,
    @AnalyticsDetails.query.axis: #ROWS
    UnitOfMeasure

    
}
