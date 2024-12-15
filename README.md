## Stealth Gas Station

This is a simple contract that facilitates an anonymous gas ticketing scheme.

Users forward a common denomination of ETH to the `StealthGasStation` contract along with some "blinded data" (using the `buyGasTickets` function). 

The `coordinator` validates gas ticket purchases and subsequently signs the blinded data and returns a blind signature to users (using the `remitGasTickets` function). 

Now users can unblind the signature to get a valid rsa signature over their data.
