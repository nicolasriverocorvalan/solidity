// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract TransferUSDC is OwnerIsCreator {
    using SafeERC20 for IERC20;

    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees);
    error DestinationChainNotAllowlisted(uint64 destinationChainSelector);
    error NothingToWithdraw();

    IRouterClient private immutable i_ccipRouter;
    IERC20 private immutable i_linkToken;
    IERC20 private immutable i_usdcToken;

    mapping(uint64 => bool) public allowlistedChains;

    modifier onlyAllowlistedChain(uint64 _destinationChainSelector) {
        if (!allowlistedChains[_destinationChainSelector])
            revert DestinationChainNotAllowlisted(_destinationChainSelector);
        _;
    }

    event UsdcTransferred(
        bytes32 messageId,
        uint64 destinationChainSelector,
        address receiver,
        uint256 amount,
        uint256 ccipFee
    );

    constructor(address ccipRouter, address linkToken, address usdcToken) {
        i_ccipRouter = IRouterClient(ccipRouter);
        i_linkToken = IERC20(linkToken);
        i_usdcToken = IERC20(usdcToken);
    }

    function allowlistDestinationChain(
        uint64 _destinationChainSelector,
        bool _allowed
    ) external onlyOwner {
        allowlistedChains[_destinationChainSelector] = _allowed;
    }

    function transferUsdc(
        uint64 _destinationChainSelector,
        address _receiver,
        uint256 _amount,
        uint64 _gasLimit
    )
        external
        onlyOwner
        onlyAllowlistedChain(_destinationChainSelector)
        returns (bytes32 messageId)
    {
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(i_usdcToken),
            amount: _amount
        });
        tokenAmounts[0] = tokenAmount;

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver),
            data: "",
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: _gasLimit})
            ),
            feeToken: address(i_linkToken)
        });

        uint256 ccipFee = i_ccipRouter.getFee(
            _destinationChainSelector,
            message
        );

        if (ccipFee > i_linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(
                i_linkToken.balanceOf(address(this)),
                ccipFee
            );

        i_linkToken.approve(address(i_ccipRouter), ccipFee);

        i_usdcToken.safeTransferFrom(msg.sender, address(this), _amount);
        i_usdcToken.approve(address(i_ccipRouter), _amount);

        // Send CCIP Message
        messageId = i_ccipRouter.ccipSend(_destinationChainSelector, message);

        emit UsdcTransferred(
            messageId,
            _destinationChainSelector,
            _receiver,
            _amount,
            ccipFee
        );
    }

    function withdrawToken(
        address _beneficiary,
        address _token
    ) public onlyOwner {
        uint256 amount = IERC20(_token).balanceOf(address(this));

        if (amount == 0) revert NothingToWithdraw();

        IERC20(_token).transfer(_beneficiary, amount);
    }
}
