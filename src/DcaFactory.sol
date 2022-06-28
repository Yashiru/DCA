// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "@chainlink/contracts/src/v0.8/libraries/internal/Cron.sol";
import "@chainlink/contracts/src/v0.8/factories/CronUpkeepFactory.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract DcaFactory {
    CronUpkeepFactory public cronUpKeepFactory;
    LinkTokenInterface public linkToken;
    uint256 public counter;

    constructor(address _cronUpKeepFactory, address _linkToken) {
        cronUpKeepFactory = CronUpkeepFactory(_cronUpKeepFactory);
        linkToken = LinkTokenInterface(_linkToken);
    }

    function createDcaPosition(string memory cronString) public {
        Spec memory spec = Cron.toSpec(cronString);
        cronUpKeepFactory.newCronUpkeepWithJob(abi.encode(
            address(this), 
            bytes4(keccak256("performDca()")), 
            spec
        ));
    }

    function performDca() public {
        counter = counter + 1;
    }
}
