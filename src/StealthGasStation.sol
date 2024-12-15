// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StealthGasStation {
    error WrongValue();
    error OnlyCoordinator();
    error TransferFailed();
    error LengthMismatch();

    event BuyGasTickets(bytes[] blinded);
    event RemitGasTickets(bytes32[] hashes, bytes[] signed);
    event NativeTransfers(uint256[] amounts, address[] targets);

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

    function remitGasTickets(bytes32[] calldata hashes, bytes[] calldata blindSigned) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();

        uint256 len = hashes.length;
        if (len != blindSigned.length) revert LengthMismatch();

        emit RemitGasTickets(hashes, blindSigned);
    }

    function sendGas(uint256[] calldata amounts, address[] calldata targets) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();
        
        uint256 len = amounts.length;
        if (len != targets.length) revert LengthMismatch();
        
        for (uint256 i = 0; i < len; i++) {
            (bool success, ) = payable(targets[i]).call{value: amounts[i]}("");
            if (!success) revert TransferFailed();
        }

        emit NativeTransfers(amounts, targets);
    }
}
