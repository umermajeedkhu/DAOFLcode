// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Import the openzepplin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract FLNFTC is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // mapping for token URIs
    mapping (uint256 => string) private tokenURIs;
    mapping (uint256 => address) public  OrchestratorAddresses;
    mapping (uint256 => string) private GMCIDs;
    string public baseURI;  

    // all tokens in this contract should have unique tokenURI // can be assigned repeatedly if required but at the time they should be unique
    // this mapping assign 1 to the currently active tokenURI
    mapping(string => uint8) private tokenURIcheck;
    // all tokens in this contract should have unique  OrchestratorAddress// can be assigned repeatedly if required but at the time they should be unique
    // this mapping assign 1 to the currently active  OrchestratorAddress
    mapping(address => uint8) private OrchestratorAddressCheck;
    // all tokens in this contract should have unique GMCID // can be assigned repeatedly if required but at the time they should be unique
    // this mapping assign 1 to the currently active GMCID
    mapping(string => uint8) private GMCIDcheck;

    event TokenURIset(uint indexed FLNFTID, string _tokenURI);
    event GMCIDset(uint indexed FLNFTID, string _GMCID);
    event OrchestratorAddressSet(uint indexed FLNFTID, address indexed _OrchestratorAddress);


    constructor(string memory _name, string memory _symbol, string memory __baseURI) ERC721(_name, _symbol) {

        baseURI = __baseURI;
    }


    function getGMCID(uint _tokenId) public view returns (string memory _GMCID){
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        

        _GMCID = GMCIDs[_tokenId];

        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_GMCID).length > 0) {
            _GMCID = string(abi.encodePacked(baseURI, _GMCID));
        }
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal   {
        super._beforeTokenTransfer(from, to, tokenId,1);

        
    }

 

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory _tokenURI) {
        
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        

       _tokenURI = tokenURIs[_tokenId];

        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            _tokenURI = string(abi.encodePacked(baseURI, _tokenURI));
        }
    }

    function _is_OrchestratorAddress(address _address, uint256 _tokenId) internal view returns (bool) {
        require(_exists(_tokenId), "ERC721: operator query for nonexistent token");
        address _owner = OrchestratorAddresses[_tokenId];
        return (_address == _owner);
    }

    function assignTokenURI(uint256 _tokenId, string memory _tokenURI) public  returns (bool){
        require(_exists(_tokenId), "ERC721Metadata: URI set of nonexistent token");
        
        require(_is_OrchestratorAddress( _msgSender(), _tokenId) ,"caller is not coressponding contract address");
        
        require(tokenURIcheck[_tokenURI] != 1, "Provided _tokenURI already exist");
        string memory _currtokenURI = tokenURIs[_tokenId];
        tokenURIs[_tokenId] = _tokenURI;
        tokenURIcheck[_currtokenURI] = 0;
        tokenURIcheck[_tokenURI] = 1;
        
        emit TokenURIset( _tokenId,  _tokenURI);
        return true;
    }

    function assignGMCID(uint256 _tokenId, string memory _GMCID) public returns (bool){
        require(_exists(_tokenId), "ERC721Metadata: _GMCID set of nonexistent token");
        
        require(_is_OrchestratorAddress( _msgSender(), _tokenId),"caller is not coressponding contract address");
        
        require(GMCIDcheck[_GMCID] != 1, "Provided _GMCID already exist");
        string memory _currGMCID = GMCIDs[_tokenId];
        GMCIDs[_tokenId] = _GMCID;
        GMCIDcheck[_currGMCID] = 0;
        GMCIDcheck[_GMCID] = 1;
        emit GMCIDset( _tokenId, _GMCID);
        return true;
    }


    function craftFLNFT(address minter, address _OrchestratorAddress, string memory _tokenURI, string memory _GMCID) public returns (uint256){

        require(tokenURIcheck[_tokenURI] != 1, "Provided _tokenURI already exist");
        require(GMCIDcheck[_GMCID] != 1, "Provided _GMCID already exist");
        require(OrchestratorAddressCheck[_OrchestratorAddress] != 1, "Provided _OrchestratorAddress already exist");
        
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();
        _mint(minter, _tokenId);
        require(_exists(_tokenId), "ERC721Metadata: nonexistent token");
        OrchestratorAddresses[_tokenId] = _OrchestratorAddress;
        emit OrchestratorAddressSet(_tokenId,  _OrchestratorAddress);
        GMCIDs[_tokenId] = _GMCID;
        emit GMCIDset( _tokenId,  _GMCID);
        tokenURIs[_tokenId] = _tokenURI;
        emit TokenURIset( _tokenId,  _tokenURI);
        return _tokenId;

    }

    function renounceOwnership() public view override onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }


    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        revert("can't transferOwnership here"); //not possible with this smart contract
        
    }




}