@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Prosessor Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_HA_BOOKING_PROSESSOR as projection on ZATS_HA_BOOKING
{
  key TravelId,
//   @Consumption.valueHelpDefinition: [{ 
//      entity.name: '/DMO/I_Booking_M',
//      entity.element: 'booking_id'
//     }] 
  key BookingId,
  BookingDate,
  @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Customer',
      entity.element: 'CustomerID'
     }] 
  CustomerId,
  @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Carrier',
      entity.element: 'AirlineID'
     }] 
  CarrierId,
  @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Connection',
      entity.element: 'ConnectionID',
//      Additional Binding - Is to get only connections(ConnectionId) related to the airlineId(CarrierId) selected
      additionalBinding: [{  
                            localElement: 'CarrierId',
                            element: 'AirlineID'
      }]
     }] 
  ConnectionId,
  FlightDate, 
  @Semantics.amount.currencyCode: 'CurrencyCode'
  FlightPrice,
  @Consumption.valueHelpDefinition: [{ 
      entity.name: 'I_Currency',
      entity.element: 'Currency'
     }] 
  CurrencyCode,
  @Consumption.valueHelpDefinition: [{ 
      entity.name: '/DMO/I_Booking_Status_VH',
      entity.element: 'BookingStatus'
     }] 
  BookingStatus,
  LastChangedAt,
  _Customer.LastName,
  _Customer.FirstName,
  /* Associations */
  _BookingStatus,
  _BookingStatusText,
  _Carrier,
  _Connection,
  _Customer,
  _Supplements: redirected to composition child ZATS_HA_BOOKSUPPL_PROSESSOR,
  _Travel : redirected to parent zats_ha_travel_prosessor
    
}
