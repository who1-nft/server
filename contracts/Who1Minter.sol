pragma solidity ^0.5.6;

import "./base/ownership/Ownable.sol";
import "./base/math/SafeMath.sol";
import "./Who1.sol";

contract Who1Minter is Ownable {
    using SafeMath for uint256;

    Who1 public nft;
    uint256 public mintPrice = 50 * 1e18;
    address payable public feeTo;
    uint256 public maxCount = 20;
    uint256 public limit;

    uint256 public step = 0;
    mapping(address => bool) public whitelist1;
    mapping(address => bool) public whitelist2;

    constructor(Who1 _nft, address payable _feeTo) public {
        nft = _nft;
        feeTo = _feeTo;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function setFeeTo(address payable _feeTo) external onlyOwner {
        feeTo = _feeTo;
    }

    function setMaxCount(uint256 _maxCount) external onlyOwner {
        maxCount = _maxCount;
    }

    function setLimit(uint256 _limit) external onlyOwner {
        limit = _limit;
    }

    function setStep(uint256 _step) external onlyOwner {
        step = _step;
    }

    function addWhitelist1(address[] calldata addrs) external onlyOwner {
        for (uint256 i = 0; i < addrs.length; i = i.add(1)) {
            whitelist1[addrs[i]] = true;
        }
    }

    function removeWhitelist1(address[] calldata addrs) external onlyOwner {
        for (uint256 i = 0; i < addrs.length; i = i.add(1)) {
            whitelist1[addrs[i]] = false;
        }
    }

    function addWhitelist2(address[] calldata addrs) external onlyOwner {
        for (uint256 i = 0; i < addrs.length; i = i.add(1)) {
            whitelist2[addrs[i]] = true;
        }
    }

    function removeWhitelist2(address[] calldata addrs) external onlyOwner {
        for (uint256 i = 0; i < addrs.length; i = i.add(1)) {
            whitelist2[addrs[i]] = false;
        }
    }

    function mint(uint256 count) payable external {
        require(count <= limit && count <= maxCount);
        require(msg.value == mintPrice.mul(count));
        require(
            (step == 1 && whitelist1[msg.sender]) ||
            (step == 2 && whitelist2[msg.sender]) ||
            step == 3
        );
        uint256 totalSupply = nft.totalSupply();
        for (uint256 i = totalSupply; i < totalSupply.add(count); i = i.add(1)) {
            nft.mint(msg.sender, i);
        }
        feeTo.transfer(msg.value);
        limit = limit.sub(count);
    }
}
