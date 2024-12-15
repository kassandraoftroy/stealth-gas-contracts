// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StealthGasStation} from "../src/StealthGasStation.sol";

contract StealthGasTest is Test {
    StealthGasStation public gasStation;
    address constant owner = 0xB453Cb3b96101e597eF0CF201a92777f721849ae;

    function setUp() public {
        gasStation = new StealthGasStation(
            owner,
            10**14,
            bytes("abcdefg")
        );
    }

    function test_gasStation() public {
        bytes[] memory a = new bytes[](2);
        a[0] = bytes("aaaaaaaa");
        a[1] = bytes("bbbbbbbb");
        gasStation.buyGasTickets{value: 0.0002 ether}(a);

        assertEq(address(gasStation).balance, 0.0002 ether);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.00021 ether}(a);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0003 ether}(a);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0001 ether}(a);

        bytes32[] memory b = new bytes32[](2);
        vm.expectRevert();
        gasStation.remitGasTickets(b, a);

        vm.prank(owner);
        gasStation.remitGasTickets(b, a);

        b = new bytes32[](3);
        vm.expectRevert();
        vm.prank(owner);
        gasStation.remitGasTickets(b, a);

        uint256 balBefore = owner.balance;
        uint256[] memory x = new uint256[](1);
        x[0] = 0.0001 ether;
        address[] memory t = new address[](1);
        t[0] = owner;
        vm.expectRevert();
        gasStation.sendGas(x, t);

        vm.prank(owner);
        gasStation.sendGas(x, t);

        assertEq(owner.balance-balBefore, 0.0001 ether);
        assertEq(address(gasStation).balance, 0.0001 ether);
        assertEq(gasStation.coordinator(), owner);
        assertEq(gasStation.coordinatorPubKey(), bytes("abcdefg"));
    }
}
