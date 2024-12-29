@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ATS_HA_BPA
  as select from zats_ha_bpa
  association [1] to I_Country as _country on $projection.Country = _country.Country
{
  key bp_id                                                           as BpId,
      bp_role                                                         as BpRole,
      company_name                                                    as CompanyName,
      street                                                          as Street,
      country                                                         as Country,
      region                                                          as Region,
      city                                                            as City,
      _country._Text[Language = $session.system_language].CountryName as countryname
}
