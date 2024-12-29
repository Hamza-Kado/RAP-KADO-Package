@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
define view entity ZI_ATS_HA_SALES
  as select from zats_ha_so_hdr as _hdr
  association [1..*] to zats_ha_so_item as _items on $projection.OrderId = _items.order_id
{
  key _hdr.order_id as OrderId,
  _hdr.order_no as OrderNo,
  _hdr.buyer as Buyer,
  _hdr.created_on as CreatedOn,
  _hdr.created_by as CreatedBy,
  _items
}
