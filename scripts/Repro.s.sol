// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {MetisScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';

contract Test {
  function helloMetis() external pure returns (string memory) {
    return 'hello';
  }
}

contract TestDeploy is MetisScript {
  function run() external broadcast {
    new Test();
    new Test();
  }
}
