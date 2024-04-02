// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ITransferProxy.sol";

contract TransferProxy is ITransferProxy, Ownable {
    using SafeERC20 for IERC20;

    event OperatorChanged(address indexed from, address indexed to);

    address public operator;

    constructor() Ownable(msg.sender) {
        operator = msg.sender;
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Only operator can call this function");
        _;
    }

    function changeOperator(address _operator) external onlyOwner {
        require(_operator != address(0), "Operator: new operator is the zero address");
        operator = _operator;
        emit OperatorChanged(operator, _operator);
    }

    function erc721safeTransferFrom(
        IERC721 token,
        address from,
        address to,
        uint256 tokenId
    ) external  onlyOperator {
        token.safeTransferFrom(from, to, tokenId);
    }

    function erc20SafeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) external  onlyOperator {
        token.safeTransferFrom(from, to, value);
    }
}
