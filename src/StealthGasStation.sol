// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StealthGasStation {
    error WrongValue();
    error OnlyCoordinator();
    error TransferFailed();

    event BuyGasTickets(bytes[] blinded);
    event RemitGasTickets(bytes[] signed);

    address public immutable coordinator;
    uint256 public immutable ticketSize;
    bytes public coordinatorPubKey;

    constructor(address _owner, uint256 _size, bytes memory _pubKey) {
        coordinator = _owner;
        ticketSize = _size;
        coordinatorPubKey = _pubKey;
    }

    function buyGasTickets(bytes[] calldata blindedData) payable external {
        if (blindedData.length*ticketSize != msg.value) revert WrongValue();

        emit BuyGasTickets(blindedData);
    }

    function remitGasTickets(bytes[] calldata blindSigned) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();

        emit RemitGasTickets(blindSigned);
    }

    function sendGas(uint256 amount, address to) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();

        (bool success, ) = payable(to).call{value: amount}("");
        if (!success) revert TransferFailed();
    }
}
