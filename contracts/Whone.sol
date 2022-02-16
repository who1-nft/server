// SPDX-License-Identifier: MIT
pragma solidity  ^0.5.6;

import "openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol";
import "./base/ownership/Ownable.sol";
import "./base/token/KIP7/IKIP7.sol";
import "./base/token/KIP17/KIP17Full.sol";
import "./base/token/KIP17/KIP17Pausable.sol";

// @title Admin contract for Who1. Holds owner-only functions to adjust
//        fee, contract lists, parameters, etc.
contract WhoneAdmin is Ownable, Pausable, ReentrancyGuard {

    /* ****** */
    /* EVENTS */
    /* ****** */

    // @notice This event is fired whenever the admins change the percent of
    //         interest rates earned that they charge as a fee. Note that
    //         newAdminFee can never exceed 10,000, since the fee is measured
    //         in basis points.
    // @param  newShareRate - The new profit share rate measured in basis points. 
    //         This is the percentage of the distribution of proceeds upon 
    //         completion of the NFT sale to the contract admins.
    event ProfitShareRateUpdated(
        uint256 newShareRate
    );

    /* ******* */
    /* STORAGE */
    /* ******* */

    // @notice A mapping from an KIP7 currency address to whether that
    //         currency is whitelisted to be used by this contract. Note that
    //         Who1 only supports tokens that use KIP7 currencies that are
    //         whitelisted, all other calls will fail.
    mapping (address => bool) public kip7CurrencyIsWhitelisted;

    // @notice A mapping from an NFT contract's address to whether that
    //         contract is whitelisted to be used by this contract. Note that
    //         Who1 only supports NFTs from contracts that are whitelisted, 
    //         all other calls will fail.
    mapping (address => bool) public nftContractIsWhitelisted;

    uint256 public shareRateInBasisPoints = 7000; // 70%

    /* *********** */
    /* CONSTRUCTOR */
    /* *********** */

    constructor() internal {
        // Whitelist mainnet KUSDT
        kip7CurrencyIsWhitelisted[address(0xceE8FAF64bB97a73bb51E115Aa89C17FfA8dD167)] = true;
        // Whitelist mainnet KDAI
        kip7CurrencyIsWhitelisted[address(0x5c74070FDeA071359b86082bd9f9b3dEaafbe32b)] = true;

        // Whitelist mainnet Krafterspace
        nftContractIsWhitelisted[address(0x9facCd9f9661ddDec3971c1ee146516127c34fc1)] = true;
    }

    /* ********* */
    /* FUNCTIONS */
    /* ********* */

    // @notice This function can be called by admins to change the whitelist
    //         status of an KIP7 currency. This includes both adding an KIP7
    //         currency to the whitelist and removing it.
    // @param  _kip7Currency - The address of the KIP7 currency whose whitelist
    //         status changed.
    // @param  _setAsWhitelisted - The new status of whether the currency is
    //         whitelisted or not.
    function whitelistKIP7Currency(address _kip7Currency, bool _setAsWhitelisted) external onlyOwner {
        kip7CurrencyIsWhitelisted[_kip7Currency] = _setAsWhitelisted;
    }

    // @notice This function can be called by admins to change the whitelist
    //         status of an NFT contract. This includes both adding an NFT
    //         contract to the whitelist and removing it.
    // @param  _nftContract - The address of the NFT contract whose whitelist
    //         status changed.
    // @param  _setAsWhitelisted - The new status of whether the contract is
    //         whitelisted or not.
    function whitelistNFTContract(address _nftContract, bool _setAsWhitelisted) external onlyOwner {
        nftContractIsWhitelisted[_nftContract] = _setAsWhitelisted;
    }

    // @notice This function can be called by admins to change the percent of
    //         profit share rates earned that they sell NFTs. Note that
    //         newShareRate can never exceed 10,000, since the rate is measured
    //         in basis points.
    // @param  _newAdminFeeInBasisPoints - The new admin fee measured in basis points. This
    //         is a percent of the interest paid upon a loan's completion that
    //         go to the contract admins.
    function updateAdminFee(uint256 _newShareRateInBasisPoints) external onlyOwner {
        require(_newShareRateInBasisPoints <= 10000, 'By definition, basis points cannot exceed 10000');
        shareRateInBasisPoints = _newShareRateInBasisPoints;
        emit ProfitShareRateUpdated(_newShareRateInBasisPoints);
    }
}

