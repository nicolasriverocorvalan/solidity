pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Royalties.sol";

// "is" smart contract inherits from Test
contract RoyaltiesTest is Test {
  Royalties private royalties;
  address private owner;

  string private name = "Royalties";
  string private symbol = "ROYAL";
  uint96 private defaultFeeNumerator = 100;

  address private nico = makeAddr("nico");
  address private maria = makeAddr("maria");


  /*setUp() is a special function you can define within your test contract to setup initial state and conditions for testing. It's executed
     before each individual test function within the contract.
  */
  function setUp() public {
    // store the address of its owner
    owner = address(this);

    // create an instance of Royalties smart contract and. "new" invokes the constructor
    royalties = new Royalties(name, symbol, defaultFeeNumerator);
  }

  // assertEq, built-in assertion function, used for equality comparisons
  function testInitialState() public {
    assertEq(royalties.name(), name, "The name should be Royalties");
    assertEq(royalties.symbol(), symbol, "The symbol should be ROYAL");
  }

  // testing supports interface function, should return true
  function testSupportsERC721Interface() public {
    assertEq(royalties.supportsInterface(0x80ac58cd), true);
  }

  // testing supports interface function, should return true
  function testSupportsERC2981Interface() public {
    assertEq(royalties.supportsInterface(0x2a55205a), true);
  }

  // testing wheter minting new tokes works as expected
  function testMintNFT() public {

    // ensure that the recipient and the toke URI are correct. Nico is the owner of the NFT
    uint256 tokenId = royalties.mintNFT(nico, "tokenURI");
    assertEq(royalties.ownerOf(tokenId), nico);
    assertEq(royalties.tokenURI(tokenId), "tokenURI");
  }

  // verify that the royalty is set as expected. Royality will be paid out to Maria
  function testReturnsRoyaltyInfo() public {
    uint256 tokenId = royalties.mintNFTWithRoyalty(juan, "tokenURI", maria, 1000);

    // destructing assigment to extract individual elements from cpmplex data structure
    (address receiver, uint256 amount) = royalties.royaltyInfo(tokenId, 500); //royaltyInfo(tokenId, salePrice)
    assertEq(receiver, maria);
    assertEq(amount, 50); // 50=(500*1000)/10000
  }
}
