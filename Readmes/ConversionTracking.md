# Conversion tracking

Conversion tracking is used to send analytics events for Conversion tracking. By tracking the conversions you will be able to see more detailed information about sales and product-to-show connections in the Bambuser Dashboard.

To setup *Conversation tracking* with the BambuserPlayerSDK, create an instance of `BambuserConversionTracking` where you need to use it. Once the user places a purchase you need to send that purchase event to the conversion tracker instance.

As the player handles all connections to shows and products internally you dont need to send any information about what show is being displayed. All you need to handle is when a purchase is made.

## Sending a purchase event

When a user places an order you should send a purchase event.

 ```swift
 let tracking = BambuserConversionTracking()
 
 // create a new event to track purchases
 // replace the values with your data
 let event = PurchaseTrackingEvent(
     orderId: "123", // the order id
     orderValue: 12345.0, // total of all products in the order
     orderProductIds: ["1", "2", "3"], // array of all product ids in the order
     currency: "USD" // the currency used for the order (ISO 4217)
 )
 
 // send the data to Bambuser
 tracking.collect(event)
 ```
