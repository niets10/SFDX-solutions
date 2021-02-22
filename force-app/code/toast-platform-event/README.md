# Introduction
Toast platform event will show a toast when a relevant change has been made to a record.

For example, if we have an `Opportunity` that is moved to a stage called *Proposed Price*, we would need to set the `Amount` of the `Opportunity`. This could be, of course, done with a validation rule, but that would prevent to set the status to *Proposed Price* and maybe that is not what we want, we might want to show only an alert, a reminder of an action that needs to be done.

So if the `Opportunity` is moved to *Proposed Price* and the `Amount` is not filled, then a toast will show with some information like Hey! Remember to fill the amount.

# How to

Sounds great! How do we do that?

We use a Platform Event and a LWC to subscribe to it. Whenever a relevant change has been made, an event will be published to the channel of the Platform Event using flows, process builders, triggers, etc (whatever you want) and the LWC subscribed to the event will show up!

## Platform Event

Configure a Platform Event with any name that is relevant, in this case is Toast__e.

Create any fields that are relevant, in this case I have configured four fields to pass information to the Toast element that will be shown in the LWC:

`Title__c` → Title of the toast; in a Toast element, the title is mandatory.
`Message__c` → Message of the toast; in a Toast element, the message is mandatory.
`Variant__c` → Appearance of the toast. Valid values are: info (default), success, warning, and error.
`Mode__c` → How persistent the toast is. Valid values are: dismissible (default), remains visible until you click the close button or 3 seconds has elapsed, whichever comes first; pester, remains visible for 3 seconds and disappears automatically. No close button is provided; sticky, remains visible until you click the close button.

## Flow

Used to publish the event to `Toast__e` and pass values to the fields mentioned before. 

Other solutions like Process Builder or triggers could be used too!

## Lightning Web Component

The component will subscribe to the Platform Event channel when it initializes using the function `connectedCallback()`.

Inside the function we need to use the function `subscribe()` which will execute a function that be passed as parameter, in this case call `showToastEvent()` passing the response as parameter.

This response will contain the information about the published event in the form of an object, which we can destructure to get the fields from `Toast__e`.

Using these fields, we can populate the information of the toast to be shown.