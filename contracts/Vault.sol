// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint256) GrantDeposit;

    struct GrantDepositDetails {
        address Beneficiary;
        uint256 Amount;
        uint256 UnlockTime;
    }

    GrantDepositDetails[] grantArray;

    function CreateNewGrant(
        address payable _beneficiary,
        uint256 _unlockTime
    ) external payable {
        GrantDeposit[_beneficiary] = msg.value;

        uint256 _timeToUnlock = 365 * 24 * 60 * _unlockTime;
        GrantDepositDetails memory details;
        details.Beneficiary = _beneficiary;
        details.Amount = msg.value;
        details.UnlockTime = _timeToUnlock + block.timestamp;

        grantArray.push(details);
    }

    function ViewGrants() external view returns (GrantDepositDetails[] memory) {
        return grantArray;
    }

    function ViewMapping(address _beneficiary) external view returns (uint256) {
        return GrantDeposit[_beneficiary];
    }

    function WithdrawGrant(uint256 _grantId) external payable {
        require(GrantDeposit[msg.sender] > 0);

        GrantDepositDetails memory details = grantArray[_grantId];
        require(details.UnlockTime > block.timestamp, "not yet unlock time");
        payable(details.Beneficiary).transfer(details.Amount);
    }

    fallback() external payable {}

    receive() external payable {}
}
