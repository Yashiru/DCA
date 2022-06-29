// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "@chainlink/contracts/src/v0.8/libraries/internal/Cron.sol";
import "@chainlink/contracts/src/v0.8/factories/CronUpkeepFactory.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/KeeperRegistrar.sol";


/// @notice Contract that create DCA positions by calling chainlink protocol.
///         In this exemple, this contract is also the "Target contract" that 
///         will be called by the deployed cron contracts. Cron contracts will
///         be configured to call performDca().
/// @dev This contract is NOT optimized at all, this is only for PoC purpose.
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

    /// @notice Create a DCA position by creating and registering a new 
    ///         Chainlink Cron job
    /// @param cronString The cron string => https://en.wikipedia.org/wiki/Cron
    function createDcaPosition(string memory cronString) public {
        // Compute the configuration of the cron job
        // This should be called off-chain because it is very expensive
        bytes memory encodedJob = cronUpKeepFactory.encodeCronJob(
            address(this),
            abi.encodePacked(bytes4(keccak256("performDca()"))),
            cronString
        );

        // Deploy a new cron contract by calling cron upkeep factory
        cronUpKeepFactory.newCronUpkeepWithJob(encodedJob);

        // Transfer some link to this contract
        linkToken.transferFrom(msg.sender, address(this), 5 ether);

        // Compute the link token contract delegate call calldatas to perform a 
        // transferAndCall to register the new deployed Cron contract
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

        // Transfer the links to the registrar and register the new cron
        linkToken.transferAndCall(address(keeperRegistrar), 5 ether, data);
    }

    /// @notice function called by the deployed cron contracts
    function performDca() external {
        counter = counter + 1;
    }

    /// @notice function to withdraw locked link
    function withdrawLink() public {
        linkToken.transfer(
            0xdB75A7BE5BD568dA00ad2A949Eb9cF966759FA41,
            linkToken.balanceOf(address(this))
        );
    }
}
