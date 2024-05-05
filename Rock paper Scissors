// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract RockPaperScissor {
    struct Play {
        bytes32 blindedMove;
        uint256 deposit;
    }
    address payable public beneficiary;
    address payable public player1;
    address payable public player2;
    uint256 public playingEnd;
    uint256 public revealEnd;
    uint256 public reward;
    //Moves
    //1 rock
    //2 paper
    //3 scissor
    uint256 public move1;
    uint256 public move2;
    bool public ended;

    mapping(address => Play) public plays;

    event GameEnded(string result);

    error TooEarly(uint256 time);
    error TooLate(uint256 time);
    error GameEndAlreadyCalled();

    modifier onlyBefore(uint256 time) {
        if (block.timestamp >= time) revert TooLate(time);
        _;
    }
    modifier onlyAfter(uint256 time) {
        if (block.timestamp <= time) revert TooEarly(time);
        _;
    }

    constructor(
        uint256 playingTime,
        uint256 revealTime,
        address payable beneficiaryAddress,
        address payable p1,
        address payable p2
    ) payable {
        beneficiary = beneficiaryAddress;
        playingEnd = block.timestamp + playingTime;
        revealEnd = playingEnd + revealTime;
        reward = msg.value;
        player1 = p1;
        player2 = p2;
    }

    function play(bytes32 blindedMove) external payable onlyBefore(playingEnd) {
        require(msg.value == reward);
        plays[msg.sender] = Play({
            blindedMove: blindedMove,
            deposit: msg.value
        });
    }

    function reveal(uint256 value, bytes32 secret)
        external
        onlyAfter(playingEnd)
        onlyBefore(revealEnd)
    {
        if (msg.sender != player1 && msg.sender != player2) {
            return;
        }
        if (
            (player1 == msg.sender && move1 != 0) ||
            (player2 == msg.sender && move2 != 0)
        ) {
            revert("Already Revealed!");
        }
        if (value < 1 || value > 3) {
            revert("Invalid value!");
        }
        if (
            plays[msg.sender].blindedMove ==
            keccak256(abi.encodePacked(value, secret))
        ) {
            if (msg.sender == player1) {
                move1 = value;
                player1.transfer(plays[msg.sender].deposit);
            } else {
                move2 = value;
                player2.transfer(plays[msg.sender].deposit);
            }
        } else {
            revert("Doesn't mach blinded Play!");
        }
    }

    function gameEnd() external onlyAfter(revealEnd) {
        if (ended) {
            revert GameEndAlreadyCalled();
        }
        ended = true;
        if (move1 == 0 && move2 == 0) {
            beneficiary.transfer(
                reward + plays[player1].deposit + plays[player2].deposit
            );
            emit GameEnded("No one revealed");
            return;
        }
        if (move1 == 0) {
            emit GameEnded("Player 1 didn't play");
            player2.transfer(reward + plays[player1].deposit);
            return;
        }
        if (move2 == 0) {
            emit GameEnded("Player 2 didn't play");
            player1.transfer(reward + plays[player2].deposit);
            return;
        }
        if (move1 == move2) {
            emit GameEnded("Draw");
            player1.transfer(reward / 2);
            player2.transfer(reward / 2);
            return;
        }
        if (move1 != move2) {
            if (whoWin()) {
                emit GameEnded("Player 1 wins");
                player1.transfer(reward);
                return;
            } else {
                emit GameEnded("Player 2 wins");
                player2.transfer(reward);
                return;
            }
        }
    }

    function whoWin() internal view returns (bool success) {
        if (
            (move1 == 1 && move2 == 3) ||
            (move1 == 2 && move2 == 1) ||
            (move1 == 3 && move2 == 2)
        ) {
            return true;
        } else {
            return false;
        }
    }
}
