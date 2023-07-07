// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "./IDAOMTC.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { EnumerableSetExtra } from "./util/EnumerableSetExtra.sol";


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract DAOMTC is Ownable, ERC165, IERC721, IERC721Metadata{

    using Counters for Counters.Counter;
    using Address for address;
    using Strings for uint256;


    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from owner to token IDs
    mapping(address =>  uint256) private _TokenIDbyaddress;

    uint256 private _totalSupply;
    string private  __baseURI;
    Counters.Counter private _tokenIds;

    constructor(string memory name_, string memory symbol_, string memory baseURI_){
        _name = name_;
        _symbol = symbol_;
        _totalSupply = 0;
        __baseURI = baseURI_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view returns (string memory) {
        return __baseURI;
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory _tokenURI_) {
        _requireMinted(tokenId_);

        _tokenURI_ = string(abi.encodePacked(_baseURI()));
        
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
     */
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }



    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        // Check that tokenId was not minted by `_beforeTokenTransfer` hook
        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            // Will not overflow unless all 2**256 token ids are minted to the same owner.
            // Given that tokens are minted one by one, it is impossible in practice that
            // this ever happens. Might change if we allow batch minting.
            // The ERC fails to describe this case.
            _balances[to] += 1;
        }

        _owners[tokenId] = to;
        _totalSupply += 1;

        _TokenIDbyaddress[to]=tokenId;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }


    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

     /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

        /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) internal virtual {
        if (batchSize > 1) {
            if (from != address(0)) {
                _balances[from] -= batchSize;
            }
            if (to != address(0)) {
                _balances[to] += batchSize;
            }
        }
    }

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
     * - When `from` is zero, the tokens were minted for `to`.
     * - When `to` is zero, ``from``'s tokens were burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     * This is an internal function that does not check if the sender is authorized to operate on the token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal {

        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
        owner = ownerOf(tokenId);
        require(owner != address(0), "DAOMT: burn from the zero address");


        unchecked {
            // Cannot overflow, as that would require more tokens to be burned/transferred
            // out than the owner initially received through minting and transferring in.
            _balances[owner] -= 1;
        }
        _totalSupply -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId, 1);
    }

    function mint(address recipient) public  onlyOwner returns(bool){
        require(balanceOf(recipient)==0,"DAOMT: can't mint more than one token per address");
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();
        _safeMint(recipient,_tokenId); 
        return true;
    }

    function burn(address recipient) public  onlyOwner returns(bool){
        require(totalSupply()>3, "DAOMT: atleast 3 members should be present in DAO at a time");
        require(balanceOf(recipient)==1);
        _burn(_TokenIDbyaddress[recipient]);  
        _TokenIDbyaddress[recipient]=0;
        return true;
    }
    
    function approve(address to, uint256 tokenId) public  override {
        revert("Soulbound: can't transfer soulbound token"); 
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        revert("Soulbound: can't transfer soulbound token");
    }

    function setApprovalForAll(address operator, bool approved) public override {
        revert("Soulbound: can't transfer soulbound token");
    }

    
    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        revert("Soulbound: can't transfer soulbound token");
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
         revert("Soulbound: can't transfer soulbound token");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        revert("Soulbound: can't transfer soulbound token");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        revert("Soulbound: can't transfer soulbound token");
    }

    



}


// A contract that represents a DAO based on ODAOMTs
abstract contract DAOC is Ownable{

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSetExtra for EnumerableSet.AddressSet;
    using EnumerableSetExtra for EnumerableSet.UintSet;

    address payable private DAOMTCAddr; 


    enum voteStatus {
        notexist,
        Approve,
        Deny
    }

    // A struct to represent a joinProposal
    struct joinProposal {
        address proposer;
        address candidate;
        EnumerableSet.AddressSet voters;
        mapping (address => voteStatus) votes;
        uint256 approvalvotes;
        uint256 denialvotes;
        bool open;

    }

    struct kickProposal {
        address proposer;
        address candidate;
        EnumerableSet.AddressSet voters;
        mapping (address => voteStatus) votes;
        uint256 approvalvotes;
        uint256 denialvotes;
        bool open;
    }

    // A mapping to store the joinProposals
    mapping(address => joinProposal) private JoinProposals;

    // A mapping to store the kickProposals
    mapping(address => kickProposal) private KickProposals;

    event JPsubmitted(address indexed _candidate, address indexed _proposer);
    event KPsubmitted(address indexed _candidate, address indexed _proposer);
    event JPapprovalVote(address indexed _candidate, address indexed voter);
    event JPdenialVote(address indexed _candidate, address indexed voter);
    event KPapprovalVote(address indexed _candidate, address indexed voter);
    event KPdenialVote(address indexed _candidate, address indexed voter);
    event JPapproved(address indexed _candidate);
    event KPapproved(address indexed _candidate);
    event JPdenied(address indexed _candidate);
    event KPdenied(address indexed _candidate);
    constructor (){
    }

    // A function to propose the addition of a new member
    function proposeJoin(address _candidate) public {

        // Check that the caller has a sufficient number of tokens
        require(IDAOMTC(DAOMTCAddr).balanceOf(_msgSender()) >= 1, "caller is not DAO member");

        // Check that the proposed candidate is not a ODAO member already
        require(IDAOMTC(DAOMTCAddr).balanceOf(_candidate) == 0, "proposed candidate is a DAO member already");
        require(JoinProposals[_candidate].open==false, "joinproposal already open for this candidate");

        // Create a new joinProposal
        joinProposal storage joinproposal = JoinProposals[_candidate];
        joinproposal.proposer = _msgSender();
        joinproposal.candidate = _candidate;
        joinproposal.open = true;
        joinproposal.approvalvotes = 0;
        joinproposal.denialvotes = 0;
        joinproposal.voters.clear();
        
        emit JPsubmitted(_candidate, _msgSender());
    }

    // A function to cast a vote on a joinProposal
    function voteJoin(address _candidate, bool _vote) public {
        // Check that the proposal exists and is open
        joinProposal storage joinproposal = JoinProposals[_candidate];
        require(joinproposal.open, "Proposal does not exist or is not open");

        // Check that the caller has a sufficient number of tokens
        require(IDAOMTC(DAOMTCAddr).balanceOf(_msgSender()) >= 1, "caller is not DAO member");

        // Check that the caller has not already voted
        require(joinproposal.votes[_msgSender()]==voteStatus.notexist, "Cannot vote more than once");
        

        // Cast the vote
        if (_vote) {
            joinproposal.votes[_msgSender()]=voteStatus.Approve;
            emit JPapprovalVote(_candidate,_msgSender());

        }
        else{
            joinproposal.votes[_msgSender()]=voteStatus.Deny;
            emit JPdenialVote(_candidate,_msgSender());
        }
        joinproposal.voters.add(_msgSender());

        address[] memory toRemove = new address[](joinproposal.voters.length());

        uint removeIndex = 0;
        for (uint i = 0; i < joinproposal.voters.length(); i++) {
            address element = joinproposal.voters.at(i);
            // Check if the element satisfies the criteria
            if (IDAOMTC(DAOMTCAddr).balanceOf(element)!=1) {
                // Add the element to the list of elements to remove
                toRemove[removeIndex] = element;
                removeIndex++;
            } 
        }

        // Remove the elements that didn't satisfy the criteria
        for (uint i = 0; i < removeIndex; i++) {
            joinproposal.voters.remove(toRemove[i]);
            joinproposal.votes[toRemove[i]]=voteStatus.notexist;

        }

        // Add the member if the joinproposal has reached majority quorum
        uint totalapprovalvotes = 0;
        uint totaldenyvotes = 0;
        for (uint i = 0; i < joinproposal.voters.length(); i++) {
            if (joinproposal.votes[joinproposal.voters.at(i)]==voteStatus.Approve) {
                totalapprovalvotes++;
            }
            if (joinproposal.votes[joinproposal.voters.at(i)]==voteStatus.Deny) {
                totaldenyvotes++;
            }
        }
        
        joinproposal.approvalvotes = totalapprovalvotes;
        joinproposal.denialvotes = totaldenyvotes;
        if (joinproposal.approvalvotes > IDAOMTC(DAOMTCAddr).totalSupply()*60/100 ) {
            IDAOMTC(DAOMTCAddr).mint(joinproposal.candidate);
            emit JPapproved(_candidate);
            
            joinproposal.open = false;
            
            for (uint i = 0; i < joinproposal.voters.length(); i++) {
                joinproposal.votes[joinproposal.voters.at(i)]==voteStatus.notexist;
            }
            joinproposal.voters.clear();
            
        }

        if (joinproposal.denialvotes > IDAOMTC(DAOMTCAddr).totalSupply()*60/100 ) {
            emit JPdenied(_candidate);
            joinproposal.open = false;
            
            for (uint i = 0; i < joinproposal.voters.length(); i++) {
                joinproposal.votes[joinproposal.voters.at(i)]==voteStatus.notexist;
            }
            joinproposal.voters.clear();
        }
    }

        // A function to propose the removal of a member
    function proposeKick(address _candidate) public {

        // Check that the caller has a sufficient number of tokens
        require(IDAOMTC(DAOMTCAddr).balanceOf(_msgSender()) >= 1, "caller is not DAO member");

        // Check that the proposed candidate is a ODAO member 
        require(IDAOMTC(DAOMTCAddr).balanceOf(_candidate) == 1, "proposed candidate is not a DAO member");
        require(_candidate!=owner(), "can't kickout owner");
        require(KickProposals[_candidate].open==false, "kickproposal already open for this candidate");

        // Create a new kickProposal
        kickProposal storage kickproposal = KickProposals[_candidate];
        kickproposal.proposer = _msgSender();
        kickproposal.candidate = _candidate;
        kickproposal.open = true;
        kickproposal.approvalvotes = 0;
        kickproposal.denialvotes = 0;
        kickproposal.voters.clear();

        emit KPsubmitted(_candidate, _msgSender());
    }

    // A function to cast a vote on a kickProposal
    function voteKick(address _candidate, bool _vote) public {

        // Check that the proposed candidate is a ODAO member 
        require(IDAOMTC(DAOMTCAddr).balanceOf(_candidate) == 1, "proposed candidate is not a DAO member");
        
        // Check that the proposal exists and is open
        kickProposal storage kickproposal = KickProposals[_candidate];
        require(kickproposal.open, "Proposal does not exist or is not open");

       
        // Check that the caller has a sufficient number of tokens
        require(IDAOMTC(DAOMTCAddr).balanceOf(msg.sender) >= 1, "caller is not DAO member");

        // Check that the caller has not already voted
        require(kickproposal.votes[_msgSender()]==voteStatus.notexist, "Cannot vote more than once");
        

        // Cast the vote
        if (_vote) {
            kickproposal.votes[_msgSender()]=voteStatus.Approve;
            kickproposal.approvalvotes++;
            emit KPapprovalVote(_candidate,_msgSender());
        }
        else{
            kickproposal.votes[_msgSender()]=voteStatus.Deny;
            emit KPdenialVote(_candidate,_msgSender());
        }
        kickproposal.voters.add(_msgSender());

        uint removeIndex = 0;

        address[] memory toRemove = new address[](kickproposal.voters.length());


        for (uint i = 0; i < kickproposal.voters.length(); i++) {
            address element = kickproposal.voters.at(i);
            // Check if the element satisfies the criteria
            if (IDAOMTC(DAOMTCAddr).balanceOf(element)!=1) {
                // Add the element to the list of elements to remove
                toRemove[removeIndex] = element;
                removeIndex++;
            } 
        }

        // Remove the elements that didn't satisfy the criteria
        for (uint i = 0; i < removeIndex; i++) {
            kickproposal.voters.remove(toRemove[i]);
            kickproposal.votes[toRemove[i]]=voteStatus.notexist;

        }
        // Add the member if the kickroposal has reached majority quorum
        uint totalapprovalvotes = 0;
        uint totaldenyvotes = 0;
        for (uint i = 0; i < kickproposal.voters.length(); i++) {
            if (kickproposal.votes[kickproposal.voters.at(i)]==voteStatus.Approve) {
                totalapprovalvotes++;
            }
            if (kickproposal.votes[kickproposal.voters.at(i)]==voteStatus.Deny) {
                totaldenyvotes++;
            }
        }
        
        
        kickproposal.approvalvotes = totalapprovalvotes;
        kickproposal.denialvotes = totaldenyvotes;
        if (kickproposal.approvalvotes > (IDAOMTC(DAOMTCAddr).totalSupply()-1)*60/100 ) {
            kickproposal.open = false;
            IDAOMTC(DAOMTCAddr).burn(kickproposal.candidate);
            emit KPapproved(_candidate);

            for (uint i = 0; i < kickproposal.voters.length(); i++) {
                kickproposal.votes[kickproposal.voters.at(i)]==voteStatus.notexist;
                
            }
            kickproposal.voters.clear();
            
        }

        if (kickproposal.denialvotes > IDAOMTC(DAOMTCAddr).totalSupply()*60/100) {
            emit KPdenied(_candidate);
            kickproposal.open = false;
            
            for (uint i = 0; i < kickproposal.voters.length(); i++) {
                kickproposal.votes[kickproposal.voters.at(i)]==voteStatus.notexist;
            }
            kickproposal.voters.clear();
        }
    }


    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "NOWN0"); //Ownable: new owner is the zero address
        address oldOwner = owner();
        require(_newOwner != oldOwner, "NOMDFPO"); //Ownable: new owner must differ from previous owner
        _transferOwnership(_newOwner);
        if(IDAOMTC(DAOMTCAddr).balanceOf(_newOwner)==0){
            IDAOMTC(DAOMTCAddr).mint(owner());
            IDAOMTC(DAOMTCAddr).burn(oldOwner);
        }
    }


    function getDAOMTCAddr() internal view returns (address) {
        return DAOMTCAddr;
    }

    function setDAOMTCAddr(address _DAOMTCAddr) internal {
        DAOMTCAddr = payable(_DAOMTCAddr);
    }


    function getjoinProposal(address _candidate) public view returns (
    bool,
    address,
    uint256,
    uint256
    ){
        joinProposal storage joinproposal = JoinProposals[_candidate];

        return (
            joinproposal.open,
            joinproposal.proposer,
            joinproposal.approvalvotes,
            joinproposal.denialvotes
        
        );
    }

    function getJPvoters(address _candidate) public view returns(address[] memory){
        joinProposal storage joinproposal = JoinProposals[_candidate];
        uint256 numVoters = EnumerableSet.length(joinproposal.voters);
        address[] memory votersArray = new address[](numVoters);
        for (uint256 i = 0; i < numVoters; i++) {
            votersArray[i] = EnumerableSet.at(joinproposal.voters, i);
        }

        return votersArray;

    }

    function getJPvoteStatus (address _candidate, address voter) public view returns(voteStatus){

         joinProposal storage joinproposal = JoinProposals[_candidate];
         return joinproposal.votes[voter];
    }

    function getkickProposal(address _candidate) public view returns (
    bool,
    address,
    uint256,
    uint256
    ){
        kickProposal storage kickproposal = KickProposals[_candidate];

        return (
            kickproposal.open,
            kickproposal.proposer,
            kickproposal.approvalvotes,
            kickproposal.denialvotes
        
        );
    }

    function getKPvoters(address _candidate) public view returns(address[] memory){
        kickProposal storage kickproposal = KickProposals[_candidate];
        uint256 numVoters = EnumerableSet.length(kickproposal.voters);
        address[] memory votersArray = new address[](numVoters);
        for (uint256 i = 0; i < numVoters; i++) {
            votersArray[i] = EnumerableSet.at(kickproposal.voters, i);
        }

        return votersArray;

    }

    function getKPvoteStatus (address _candidate, address voter) public view returns(voteStatus){

         kickProposal storage kickproposal = KickProposals[_candidate];
         return kickproposal.votes[voter];
    }
}