// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "@chainlink/contracts/src/v0.8/libraries/internal/Cron.sol";
import "@chainlink/contracts/src/v0.8/factories/CronUpkeepFactory.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/KeeperRegistrar.sol";

contract DcaFactory {
    CronUpkeepFactory public cronUpKeepFactory;
    KeeperRegistrar public keeperRegistrar;
    LinkTokenInterface public linkToken;
    uint256 public counter;

    constructor(
        address _cronUpKeepFactory,
        address _keeperRegistrar,
        address _linkToken
    ) {
        cronUpKeepFactory = CronUpkeepFactory(_cronUpKeepFactory);
        keeperRegistrar = KeeperRegistrar(_keeperRegistrar);
        linkToken = LinkTokenInterface(_linkToken);
    }

    function createDcaPosition(string memory cronString) public {
        bytes memory encodedJob = cronUpKeepFactory.encodeCronJob(
            address(this),
            abi.encodePacked(bytes4(keccak256("performDca()"))),
            cronString
        );
        cronUpKeepFactory.newCronUpkeepWithJob(encodedJob);
        linkToken.transferFrom(msg.sender, address(this), 5 ether);

        bytes memory data = abi.encodeWithSignature(
            "register(string,bytes,address,uint32,address,bytes,uint96,uint8)",
            "DCA",
            abi.encode("email"),
            address(this),
            5000000,
            msg.sender,
            "",
            5 ether,
            0
        );

        linkToken.transferAndCall(address(keeperRegistrar), 5 ether, data);
    }

    function withdrawLink() public {
        linkToken.transfer(
            0xdB75A7BE5BD568dA00ad2A949Eb9cF966759FA41,
            linkToken.balanceOf(address(this))
        );
    }

    function performDca() public {
        counter = counter + 1;
    }
}
