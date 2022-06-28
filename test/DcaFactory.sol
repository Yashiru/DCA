// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "forge-std/Test.sol";
import "../src/DcaFactory.sol";
import "@chainlink/contracts/src/v0.8/libraries/internal/Cron.sol";
import "@chainlink/contracts/src/v0.8/factories/CronUpkeepFactory.sol";

contract ContractTest is Test {
    DcaFactory factory;
    function setUp() public {
        factory = new DcaFactory(
            0x7E206B547953BcE9a94B80c28F3f8a869e2D82f9,
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        );
    }

    function testCreateDcaPosition() public {
        factory.createDcaPosition("*/5 * * * *");
    }
}