// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StealthGasStation} from "../src/StealthGasStation.sol";

contract StealthGasTest is Test {
    StealthGasStation public gasStation;
    address constant coordinator = 0x0000000000000000000000000000000000000007;
    address constant admin = 0x0000000000000000000000000000000000000008;
    function setUp() public {
        gasStation = new StealthGasStation(
            coordinator,
            admin,
            10**14,
            0,
            bytes("abcdefg")
        );
    }

    function test_buyGasTickets() public {
        //
        // BUY TWO GAS TICKETS
        //
        bytes[] memory a = new bytes[](2);
        a[0] = bytes("aaaaaaaa");
        a[1] = bytes("bbbbbbbb");
        gasStation.buyGasTickets{value: 0.0002 ether}(a);

        assertEq(address(gasStation).balance, 0.0002 ether);

        //
        // WRONG VALUES REVERT
        //
        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.00021 ether}(a);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0003 ether}(a);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0001 ether}(a);

        vm.expectRevert();
        gasStation.buyGasTickets(a);

        //
        // BUY THREE GAS TICKETS
        //
        a = new bytes[](3);
        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0002 ether}(a);

        gasStation.buyGasTickets{value: 0.0003 ether}(a);

        assertEq(address(gasStation).balance, 0.0005 ether);

        //
        // TEST SHUTDOWN
        //
        assertEq(gasStation.ended(), false);
        vm.expectRevert();
        gasStation.shutdown();

        vm.expectRevert();
        vm.prank(coordinator);
        gasStation.shutdown();

        vm.prank(admin);
        gasStation.shutdown();

        assertEq(gasStation.ended(), true);

        vm.expectRevert();
        gasStation.buyGasTickets{value: 0.0003 ether}(a);

        //
        // ONLY SHUTDOWN ONCE
        //
        vm.expectRevert();
        vm.prank(admin);
        gasStation.shutdown();
    }

    function test_sendGasTickets() public {
        bytes[] memory a = new bytes[](2);
        bytes32[] memory b = new bytes32[](2);
        vm.expectRevert();
        gasStation.sendGasTickets(b, a);

        vm.prank(coordinator);
        gasStation.sendGasTickets(b, a);

        b = new bytes32[](3);
        vm.expectRevert();
        vm.prank(coordinator);
        gasStation.sendGasTickets(b, a);
    }

    function test_sendGas() public {
        bytes[] memory a = new bytes[](2);
        gasStation.buyGasTickets{value: 0.0002 ether}(a);
        //
        // SEND GAS
        //
        uint256 balBefore = coordinator.balance;
        uint256[] memory x = new uint256[](1);
        x[0] = 0.0001 ether;
        address[] memory t = new address[](1);
        t[0] = coordinator;
        bytes memory z;
        vm.expectRevert();
        gasStation.sendGas(x, t, z);

        vm.prank(coordinator);
        gasStation.sendGas(x, t, z);

        assertEq(coordinator.balance-balBefore, 0.0001 ether);
        assertEq(address(gasStation).balance, 0.0001 ether);

        vm.prank(coordinator);
        gasStation.sendGas(x, t, z);

        assertEq(coordinator.balance-balBefore, 0.0002 ether);
        assertEq(address(gasStation).balance, 0);

        vm.expectRevert();
        vm.prank(coordinator);
        gasStation.sendGas(x, t, z);
        
        //
        // READ PUBLIC DATA
        //
        assertEq(gasStation.coordinator(), coordinator);
        assertEq(gasStation.admin(), admin);
        assertEq(gasStation.ticketCost(), 10**14);
        assertEq(gasStation.shippingCost(), 0);
        assertEq(gasStation.coordinatorPubKey(), bytes("abcdefg"));
    }

    function test_shippingCost() public {
        gasStation = new StealthGasStation(
            coordinator,
            admin,
            1 ether,
            0.001 ether,
            bytes("abcdefg")
        );

        bytes[] memory a = new bytes[](2);
        a[0] = bytes("aaaaaaaa");
        a[1] = bytes("bbbbbbbb");

        vm.expectRevert();
        gasStation.buyGasTickets{value: 2 ether}(a);

        gasStation.buyGasTickets{value: 2.001 ether}(a);
        assertEq(address(gasStation).balance, 2.001 ether);

        a = new bytes[](4);

        gasStation.buyGasTickets{value: 4.001 ether}(a);
        assertEq(address(gasStation).balance, 6.002 ether);
    }
}
