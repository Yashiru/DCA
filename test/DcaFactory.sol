// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "forge-std/Test.sol";
import "../src/DcaFactory.sol";
import "@chainlink/contracts/src/v0.8/libraries/internal/Cron.sol";
import "@chainlink/contracts/src/v0.8/factories/CronUpkeepFactory.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract ContractTest is Test {
    DcaFactory factory;
    LinkTokenInterface link;
    uint256 UINT256_MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;


    function setUp() public {
        link = LinkTokenInterface(0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06);
        
        vm.prank(0xE4dDb4233513498b5aa79B98bEA473b01b101a67);  
        factory = new DcaFactory(
            0xe5aC9480a27C01A8851cD041A206047A4C01723A,
            0x6179B349067af80D0c171f43E6d767E4A00775Cd,
            address(link)
        );
        
        vm.prank(0xE4dDb4233513498b5aa79B98bEA473b01b101a67);    
        link.approve(address(factory), UINT256_MAX);
    }

    function testCreateDcaPosition() public {
        vm.prank(0xE4dDb4233513498b5aa79B98bEA473b01b101a67);  
        factory.createDcaPosition("*/5 * * * *");
    }
}
