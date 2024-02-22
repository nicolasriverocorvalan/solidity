pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Royalties is ERC721URIStorage, ERC2981, Ownable {
  /* Counters library: a clean way to manage numerical values (incrementing/decrementing/acessing/+). Allows you to directly access
  and utilize functions provided by the library within your contract */
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdsTracker;

  /* constructor: special functiuon that is automatically executed only once during contract's deployment. 
  It's primary role is to init state vars of the contract and perform any setup.*/
  constructor(string memory _name, string memory _symbol, uint96 _feeNumerator) ERC721(_name, _symbol) {
    _setDefaultRoyalty(msg.sender, _feeNumerator); 
    /* % that applies to all tokens within the contract
       - msg.sender: constructor sets the owner to msg.sender (the person who deployed it)
       - feeNumerator: default royalty amount to be assigned, expressed in basis points.
    */
  }

  // use onlyOwner modifier, which can restrict access to certain functions to only the owner
  function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
    // increment the counter to assign the NFT a unique id.
    _tokenIdsTracker.increment();

    // retrieve its value by calling the "current" function
    uint256 tokenId = _tokenIdsTracker.current();
    /*establish the ownership 
      - recipient address
      - tokenId = unique id for the newly minted NFT*/
    _safeMint(recipient, tokenId);

    // recording token's metada
    _setTokenURI(tokenId, tokenURI);
    
    return tokenId;
  }

  // use onlyOwner modifier, which can restrict access to certain functions to only the owner
  // overrride default royality when minting a new NFT
  function mintNFTWithRoyalty(address recipient, string memory tokenURI, address royaltyReceiver, uint96 feeNumerator) public onlyOwner returns (uint256) {
    uint256 tokenId = mintNFT(recipient, tokenURI);

    _setTokenRoyalty(tokenId, royaltyReceiver, feeNumerator);
    /* - tokenId: represents the id of the token for which the royalty rate is being set 
       - royaltyReceiver: address of the royalty recipient or the party entitled to receive the royalty payment for the specified token
       - feeNumerator: royalty rate expressed in basis points. The royalty amount to be paid is calculated based on the sale price and this royalty rate
    */

    return tokenId;
  }
  
  // an interface is a way to define a contract's external-facing function signatures without implementing the full contract logic
  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
    // super keyword: to call the function defined in the parent contract
    return super.supportsInterface(interfaceId);
  }

  // use onlyOwner to make sure that only the owner can burn an NFT
  function _burn(uint256 tokenId) internal virtual override onlyOwner {
    // invoke _burn
    super._burn(tokenId);

    // resets royalty information for the token id back to the global default
    _resetTokenRoyalty(tokenId);
  }

  // allow the owner to burn an NFT 
  function burnNFT(uint256 tokenId) public onlyOwner {
    _burn(tokenId);
  }
}
