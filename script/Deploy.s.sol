// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {StealthGasStation} from "../src/StealthGasStation.sol";

contract DeployScript is Script {
    StealthGasStation public stealth;

    // Searcher EOA
    address constant owner = 0x4B5BaD436CcA8df3bD39A095b84991fAc9A226F1;
    bytes constant pubkey = bytes(hex"01000100a93791bc143a949b4554c2e79ce22d2e32e01a47225241e445d1a79f74b842cd239860cefa839ed539e2e643119a0944de186da0b3d9fa5609994804eb44c72e793d0ffa230f251dc752a7c4ad0334993ed8e0b4625e013f5582a3cc18c1db10de246c20fbd17bf21ce2d05348183eca61b93cf9c5c9657af6e3202d96dccb6bcb3614ddf0481a2434ab2d75cf25865614b6c3d79b61b058f50693a384604be4971c1764ecb659a51079135613e998a7711e79426a3f9fbf662a919ab03378a30c0963b536418f149116a3f93e2d126764db7e93872ed2b2af3db5063671d2f641e90d2022c75f0222db03ba008dad08522f30b46129e73ce999887540dfcdbf26aebba338dbf6965e888a3ab66562b9ca293a93708ba21f5a2442503647d46b1d63a9835881fe8addfed0cb6924bfbaa511ba83a57f858a3e7dfb6272daacca3d24c458f3a5557a5035b290463b81754c252dd5b33ecf7ac1c3aaf9f7e2b7b7ffa2a5ee17f30a1ecff6a45364bf5e6fad44f803c5df040c05cf461bb1253ea5");

    function setUp() public {}

    function deploy() public {
        vm.startBroadcast();
        stealth = new StealthGasStation(owner, owner, 0.001 ether, 0.001 ether, pubkey);
        vm.stopBroadcast();

        console2.log("StealthGasStation deployed at: ", address(stealth));
    }
}
