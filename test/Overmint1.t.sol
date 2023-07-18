// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/Overmint1.sol";
import "../src/Attack.sol";

contract Overmint1Test is Test {
    Overmint1 public overmint1;
    Attacker public attackContract;
    address public attacker;

    function setUp() public {
        attacker = address(0x1);
        overmint1 = new Overmint1();
        vm.prank(attacker);
        attackContract = new Attacker(address(overmint1));
    }

    function testReentrant() public {
        // mint 5 NFTs
        attackContract.mint();

        // transfer all NFTs to attackers EOA
        attackContract.transfer(1);
        attackContract.transfer(2);
        attackContract.transfer(3);
        attackContract.transfer(4);
        attackContract.transfer(5);

        uint256 nftCount = overmint1.balanceOf(address(attacker));
        assertEq(nftCount, 5);
    }
}
