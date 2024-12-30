## Stealth Gas Station

This is a simple contract that facilitates an anonymous gas ticketing scheme.

Goal is maximal simplicity and immutability for the contract. There is one admin function, but just for the ability to "shut down" the contract for selling new tickets.

The contract itself just does very simple functions. The way it works together with an offchain "coordinator" is what makes the scheme interesting and is described below.

## Anonymous Gas Ticketing TLDR

STEP 1: User forwards a common denomination of ETH to the `StealthGasStation` contract along with some "blinded data" (using the `buyGasTickets` function). 

STEP 2: The `coordinator` validates gas ticket(s) purchased and subsequently signs the blinded data and returns a blind signature(s) to the user (the coordinator uses the `sendGasTickets` function to broadcast signed blinded data)

STEP 3: User can retrieve her blinded signature(s) from onchain events and "unblind" it to get a valid rsa signature from the coordinator but one which the coordinator can't link to the blinded data they initially signed.

STEP 4: User presents an unblinded signed ticket to the coordinator. As long as this "unblinded" ticket has never been used before, the coordinator considers it valid. So coordinator notes down the ticket is now used, and then sends one ticket amount of gas to the address of the user's choice.

Since the signature was forged blinded but is presented to the coordinator unblinded, the coordinator doesn't know which ticket is being used, just that one valid unused ticket is (thus, the anonymity is preserved).

Now users can buy tickets with a doxxed address and then receive eth to a fresh/unlinked address in an anonymous way.

Coordinator needs to be trusted to `sendGasTickets` after a user calls `buyGasTickets` and `sendGas` after a user presents a valid and unused signature. Coordinator also has to not to store or leak any metadata about who is presenting them with unblinded signed tickets.

How the coordinator gains users' trust (decentralized coordinator, coordinator in a TEE, etc) is outside the scope of this contract or repository.
