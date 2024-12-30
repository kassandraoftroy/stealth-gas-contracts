// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StealthGasStation {
    error WrongValue();
    error OnlyCoordinator();
    error OnlyAdmin();
    error TransferFailed();
    error LengthMismatch();
    error Shutdown();

    event BuyGasTickets(bytes[] blinded);
    event SendGasTickets(bytes32[] ids, bytes[] signed);
    event NativeTransfers(uint256[] amounts, address[] targets, bytes data);

    bytes public coordinatorPubKey;
    uint256 public immutable ticketCost;
    uint256 public immutable shippingCost;
    address public immutable coordinator;
    address public immutable admin;
    bool public ended;

    constructor(
        address _coordinator,
        address _admin,
        uint256 _ticketCost,
        uint256 _shippingCost,
        bytes memory _pubKey
    ) {
        if (_ticketCost == 0) revert();
        coordinator = _coordinator;
        admin = _admin;
        ticketCost = _ticketCost;
        shippingCost = _shippingCost;
        coordinatorPubKey = _pubKey;
    }

    function buyGasTickets(bytes[] calldata blindedData) payable external {
        if (blindedData.length*ticketCost+shippingCost != msg.value) revert WrongValue();
        if (ended) revert Shutdown();

        emit BuyGasTickets(blindedData);
    }

    function sendGasTickets(bytes32[] calldata ids, bytes[] calldata blindSigned) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();

        uint256 len = ids.length;
        if (len != blindSigned.length) revert LengthMismatch();

        emit SendGasTickets(ids, blindSigned);
    }

    function sendGas(uint256[] calldata amounts, address[] calldata targets, bytes calldata data) external {
        if (msg.sender != coordinator) revert OnlyCoordinator();
        
        uint256 len = amounts.length;
        if (len != targets.length) revert LengthMismatch();
        
        for (uint256 i = 0; i < len; i++) {
            (bool success, ) = payable(targets[i]).call{value: amounts[i]}("");
            if (!success) revert TransferFailed();
        }

        emit NativeTransfers(amounts, targets, data);
    }

    function shutdown() external {
        if (msg.sender != admin) revert OnlyAdmin();
        if (ended) revert Shutdown();
        ended = true;
    }
}
