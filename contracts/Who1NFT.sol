pragma solidity ^0.5.6;

import "./klaytn/token/KIP17/KIP17Full.sol";
import "./klaytn/drafts/Counters.sol";
import "./klaytn/ownership/Ownable.sol";

contract Who1NFT is KIP17Full, Ownable {

  using Counters for Counters.Counter;
  Counters.Counter private tokenId;

  string public nftName = "WHO1";
  string public nftSymbol = "WHN";
  bool private locked = false;

  constructor() public KIP17Full(nftName, nftSymbol){
  }

  modifier validAddress(address _addr){
    require(_addr != address(0), "Not valid address");
    _;
  }

  modifier noReentrancy() {
    require(!locked, "No reentrancy");
    locked = true;
    _;
    locked = false;
  }

  function mintNFT(string memory _tokenURI) public onlyOwner noReentrancy returns (uint256) {
    tokenId.increment();
    uint256 newId = tokenId.current();   
    _mint(msg.sender, newId);
    _setTokenURI(newId, _tokenURI);

    return newId; 
  }

  function transferNFT(address _to, uint256 _tokenId) public onlyOwner {
    safeTransferFrom(msg.sender, _to, _tokenId);
  }

  function burnNFT(uint256 _tokenId) public {
    _burn(_tokenId);
  }

  function getTotalCount() public view returns (uint256) {
    return tokenId.current();
  }
}