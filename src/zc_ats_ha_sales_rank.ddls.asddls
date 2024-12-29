@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity which joins with Table Function'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_ATS_HA_SALES_RANK 
as select from ZATS_HA_TF(p_clnt:$session.client) as ranked
inner join zats_ha_bpa as bpa on
ranked.company_name = bpa.company_name
inner join zats_ha_region as regio on
bpa.region = regio.region
{
   key ranked.company_name  as CompanyName,
   @Semantics.amount.currencyCode: 'currency'
   ranked.total_sales as Total_Sales,
   ranked.currency_code as Currency,
   ranked.customer_rank as CustomerRank,
   regio.regionname as Region
    
}
