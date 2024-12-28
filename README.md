## Stealth Gas Station

This is a simple contract that facilitates an anonymous gas ticketing scheme.

## Anonymous Gas Ticketing TLDR

Users forward a common denomination of ETH to the `StealthGasStation` contract along with some "blinded data" (using the `buyGasTickets` function). 

The `coordinator` validates gas ticket purchases and subsequently signs the blinded data and returns a blind signature to users (coordinator uses the `sendGasTickets` function to broadcast signed blinded data). 

Now users can retrieve their blinded signature and unblind it to get a valid rsa signature over their (unblinded) data. Present this to the coordinator to get gas funded to an address of your choice (coordinator uses the `sendGas` function). Since the signature was forged blinded but is presented to the coordinator unblinded, the coordinator doesn't know which ticket is being used, just that one valid unused ticket is (thus, the anonymity is preserved).

Coordinator needs to be trusted to `sendGasTickets` after a user calls `buyGasTickets` and `sendGas` after a user presents a valid and unused signature. How the coordinator gains this trust (decentralized coordinator, coordinator in a TEE) is outside the scope of this contract or repository.
