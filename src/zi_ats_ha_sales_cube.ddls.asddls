@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Composite Cube View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
define view entity ZI_ATS_HA_SALES_CUBE as select from ZI_ATS_HA_SALES
association[1] to ZI_ATS_HA_BPA as _BusinessPartner on
$projection.Buyer = _BusinessPartner.BpId
association[1] to ZI_ATS_HA_PRODUCT as _Product on 
$projection.Product = _Product.ProductId
{
  key ZI_ATS_HA_SALES.OrderId,
  key ZI_ATS_HA_SALES._items.item_id as ItemId,
      ZI_ATS_HA_SALES.OrderNo,
      ZI_ATS_HA_SALES.Buyer,
      ZI_ATS_HA_SALES.CreatedOn,
      ZI_ATS_HA_SALES.CreatedBy,
      /*Associations*/
      ZI_ATS_HA_SALES._items.product as Product,
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ZI_ATS_HA_SALES._items.amount as GrossAmount,
      ZI_ATS_HA_SALES._items.currency as CurrencyCode,
      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      ZI_ATS_HA_SALES._items.qty as Quantity,
      ZI_ATS_HA_SALES._items.uom as UnitOfMeasure,
      _Product,
      _BusinessPartner
      
    
}
