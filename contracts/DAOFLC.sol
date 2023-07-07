// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the openzepplin contracts

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { EnumerableSetExtra } from "./util/EnumerableSetExtra.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import "./IFLNFTC.sol";
import "./IFLTokenC.sol";
import "./IDAOMTC.sol";


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
    modifier onlyOwner() virtual{
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
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     */

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

contract FLTokenC is ERC20, Ownable {

    // owner of FLTokenContract should be DAOFLC
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        
    }


    function issueFLToken(address recipient)public onlyOwner returns(bool){
        _mint(recipient, 1 * 10 ** 18); 
        return true;
    }

}

contract DAOFLC is Ownable{

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSetExtra for EnumerableSet.AddressSet;
    using EnumerableSetExtra for EnumerableSet.UintSet;

    address payable public FLTokenCAddr;
    address payable public FLNFTCAddr;
    address payable public ODAOMTCAddr;
    address payable public VDAOMTCAddr;
    address payable public MultiSigCAddr;
    uint public FLNFTID=0;
    uint public GI = 0;
    string public tokenURI = "";
    string public GMCID = "";
    bool public LMUactiveF=false;

    enum LMstatus {
        notexist,
        Submitted,
        Approved,
        Denied,
        Rewarded
    }

    enum LMvoteStatus {
        notexist,
        Approve,
        Deny
    }

    struct LM {
        string LMCID;
        string LMURI;
        LMstatus status;
        EnumerableSet.AddressSet voters;
        uint256 approvalvotes;
        uint256 denyvotes;
    }

    mapping(uint => mapping (address => LM )) private LMUs; // GI -> address -> LocalModel
    mapping(uint => mapping (address => mapping (address => LMvoteStatus) )) private LMUsVotes; // GI -> addressoffltrainer -> addressofvoter -> LMvoteStatus
   
    mapping(uint => address[]) private LMuploaders;
    mapping(string => bool) private LMCIDs;
    mapping(string => bool) private LMURIs;
    mapping (uint => bool) public GIC;
    mapping (uint => bool) public LMUC; // LMUs completed for this global iteration
    mapping (uint => bool) public LMUVDRF; // LMUs Approval Disarroval completed for this global iteration
    event LMUsInitiated(uint GI); // Where GI is the global iteration for which local model uploads has been started
    event LMUsCeased(uint GI); // Where GI is the global iteration for which local model uploads has been ended
    event LMUVDRFset(uint GI); // Where GI is the global iteration for which local model uploads has been ended
    event FLNFTcreated(uint256 indexed id, string tokenURI, string GMCID);
    event LMuploaded(uint indexed gi, address indexed submitter);
    event GMupdated(uint gi, string _GMCID, string _tokenURI);
    event LMUvoted(uint indexed _GI, address indexed _LMsubmitter, address indexed voter); 
    event LMURewarded(uint indexed gi, address indexed submitter);
    event LMUDenied(uint indexed gi, address indexed submitter);
    constructor (address payable _FLNFTCAddr, address payable _ODAOMTCAddr, address payable _VDAOMTCAddr) {
        FLNFTCAddr = _FLNFTCAddr;
        ODAOMTCAddr = _ODAOMTCAddr;
        VDAOMTCAddr = _VDAOMTCAddr;
        FLTokenC fLTokenC = new FLTokenC("Federated Learning Token","FLToken"); 
        FLTokenCAddr = payable(address(fLTokenC));
    }

    modifier whenFLNFTminted() {
        require(FLNFTID!=0,"FLNFTX");  
        _;
    }

    modifier whenLMUsActive() {

        require(FLNFTID!=0,"FLNFTX");
        require(MultiSigCAddr!=address(0),"MultiSigCAddr not set");
        require(LMUactiveF,"LMUsX"); // LMUsX="LMuploads currently not active"
        _;
    }

    modifier whenLMUsNonActive() {
        require(FLNFTID!=0,"FLNFTX");
        require(MultiSigCAddr!=address(0),"MultiSigCAddr not set");
        require(!LMUactiveF,"X: LMUs active"); // X: LMUs acceptable="Error: LM uploads currently active"
        _;
    }

    modifier onlyMultiSigC(){

        require(MultiSigCAddr!=address(0),"MultiSigCAddr not set");
        require(_msgSender() == MultiSigCAddr, "caller is not MultiSig contract");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "NOWN0"); //Ownable: new owner is the zero address
        _transferOwnership(newOwner);
    }

    function setMultiSigCAddr(address payable _MultiSigCAddr) public onlyOwner{
        require(MultiSigCAddr==address(0),"MultiSigCAddr already set");
        MultiSigCAddr=_MultiSigCAddr;
    }

    function Initiate_LMUs(uint _GI) public onlyMultiSigC whenLMUsNonActive returns(bool){
        
        require(_GI==GI+1,"GI IC"); // incorrect GI provided
        
        if(GI>0){
            require(GIC[GI],"Do GMUpdate first"); //Please complete GMupdate first
        }
        LMUactiveF = true;
       
        emit LMUsInitiated(GI+1); // LocalModel Uploades Initiated

        return true;
    }

    function Cease_LMUs(uint _GI) public onlyMultiSigC whenLMUsActive returns(bool){ // cease LocalModel Uploads
        require(_GI==GI+1,"GI IC"); // incorrect GI provided
        LMUactiveF = false;
        emit LMUsCeased(GI+1); // LocalModel Uploads ceased
        LMUC[GI+1]=true;

        return true;
    }

    function createFLNFT(string memory _tokenURI, string memory _GMCID) public onlyMultiSigC returns(bool){
        require(FLNFTID==0,"FLNFTY"); //FLNFT already minted
        FLNFTID = IFLNFTC(FLNFTCAddr).craftFLNFT(owner(), address(this), _tokenURI, _GMCID);
        tokenURI = _tokenURI;
        GMCID = _GMCID;

        emit FLNFTcreated(FLNFTID, tokenURI, GMCID);
        return true;
    }


function uploadLM(string memory _LMCID, string memory _LMURI, uint _GI) public  whenLMUsActive {
    
    if (Authenticate_LMU( _LMCID,  _LMURI, _GI, msg.sender)){

        Record_LMU( _LMCID,  _LMURI, msg.sender);
        LMCIDs[_LMCID] = true;
        LMURIs[_LMURI] = true;
        emit LMuploaded(_GI, _msgSender());
    }
}


function Authenticate_LMU(string memory _LMCID, string memory _LMURI, uint _gi, address _addroffltrainer) internal view returns (bool){
        require(LMuploaders[_gi].length < 11, "LMTR"); //Local model uploads limit reached
        require(LMUs[GI+1][_addroffltrainer].status==LMstatus.notexist,"LMY"); // You have already uploaded LM
        require(GI+1==_gi,"LMUs GI X");  // LMUs for this global iteration are not accepted
        require(LMCIDs[_LMCID] != true, "_LMCID Y"); // Provided _LMCID already exist
        require(LMURIs[_LMURI] != true, "_LMURI Y"); // Provided _LMURI already exist
        return true;
    }

    function Record_LMU(string memory _LMCID, string memory _LMURI, address _addroffltrainer) internal returns (bool){
        LMuploaders[GI+1].push(_addroffltrainer);

        LM storage lm= LMUs[GI+1][_addroffltrainer];
        lm.LMCID = _LMCID;
        lm.LMURI = _LMURI;
        lm.status = LMstatus.Submitted;
        lm.approvalvotes = 0;
        lm.denyvotes = 0;
        lm.voters.clear(); 
        return true;
    }

    function Fetch_LMUx(uint _GI) public view  returns(address[] memory){
        return LMuploaders[_GI];
    }

    function Fetch_LMU(uint _GI, address LM_uploader) public view  returns(string memory, string memory, LMstatus, uint256, uint256, uint256 ){
        require(LMUs[_GI][LM_uploader].status!=LMstatus.notexist,'LMSX');

        return (LMUs[_GI][LM_uploader].LMCID,LMUs[_GI][LM_uploader].LMURI,LMUs[_GI][LM_uploader].status, LMUs[_GI][LM_uploader].approvalvotes, LMUs[_GI][LM_uploader].denyvotes, IDAOMTC(VDAOMTCAddr).totalSupply()*60/100 );
    }

    modifier onlyVDAOM(){
        require(IDAOMTC(VDAOMTCAddr).balanceOf(_msgSender()) >= 1, "caller is not VDAO member");
        _;
    }

    function voteLMU( address LM_uploader, uint _GI, bool _vote) public onlyVDAOM whenLMUsNonActive returns(bool){
        require(_GI==GI+1,"voteLMU GI X"); 
        require(LMUs[_GI][LM_uploader].status==LMstatus.Submitted,'LMUX');

        // Check that the caller has not already voted
        require(LMUsVotes[_GI][LM_uploader][_msgSender()]==LMvoteStatus.notexist, "Cannot vote more than once");
        
        // Cast the vote
        if (_vote) {
            LMUsVotes[_GI][LM_uploader][_msgSender()]=LMvoteStatus.Approve;
            LMUs[_GI][LM_uploader].approvalvotes++;
        }
        else{
            LMUsVotes[_GI][LM_uploader][_msgSender()]=LMvoteStatus.Deny;
            LMUs[_GI][LM_uploader].denyvotes++;

        }
        LMUs[_GI][LM_uploader].voters.add(_msgSender());
        emit LMUvoted(_GI, LM_uploader, _msgSender());   
        address[] memory toRemove = new address[](LMUs[_GI][LM_uploader].voters.length());
        
        uint removeIndex = 0;
        for (uint i = 0; i < LMUs[_GI][LM_uploader].voters.length(); i++) {
            address element = LMUs[_GI][LM_uploader].voters.at(i);
            // Check if the element satisfies the criteria
            if (IDAOMTC(VDAOMTCAddr).balanceOf(element)!=1) {
                // Add the element to the list of elements to remove
                toRemove[removeIndex] = element;
                removeIndex++;
            } 
        }

         // Remove the elements that didn't satisfy the criteria
        for (uint i = 0; i < removeIndex; i++) {
            LMUs[_GI][LM_uploader].voters.remove(toRemove[i]);
            LMUsVotes[_GI][LM_uploader][toRemove[i]]=LMvoteStatus.notexist;
        }

        // Approve and reward or deny the LM if the approvalvotes or denyvotes has reached majority quorum
        uint totalapprovevotes = 0;
        uint totaldenyvotes = 0;

        for (uint i = 0; i < LMUs[_GI][LM_uploader].voters.length(); i++) {
            if (LMUsVotes[_GI][LM_uploader][LMUs[_GI][LM_uploader].voters.at(i)]==LMvoteStatus.Approve) {
                totalapprovevotes++;
            }
            else if(LMUsVotes[_GI][LM_uploader][LMUs[_GI][LM_uploader].voters.at(i)]==LMvoteStatus.Deny){
                totaldenyvotes++;
            }
        }
        
        LMUs[_GI][LM_uploader].approvalvotes = totalapprovevotes;
        LMUs[_GI][LM_uploader].denyvotes = totaldenyvotes;
        if (LMUs[_GI][LM_uploader].approvalvotes >  IDAOMTC(VDAOMTCAddr).totalSupply()*60/100 ) {


            bool statusminted = IFLTokenC(FLTokenCAddr).issueFLToken(LM_uploader);
            if(statusminted){
                LMUs[_GI][LM_uploader].status = LMstatus.Rewarded;
                emit LMURewarded(_GI,LM_uploader);
            }
            
        }
        else if(LMUs[_GI][LM_uploader].denyvotes >  IDAOMTC(VDAOMTCAddr).totalSupply()*60/100 ){
            LMUs[_GI][LM_uploader].status = LMstatus.Denied;
            emit LMUDenied(_GI,LM_uploader);
        }

        return true;
    }


    function setLMUVDRF(uint _GI) public onlyMultiSigC whenLMUsNonActive returns(bool){
        require(_GI==GI+1,"GI IC"); // incorrect GI provided
        require(LMUC[_GI],"ceaseLMU X"); // LMUs not ceased
        LMUVDRF[_GI]=true;
        emit LMUVDRFset(_GI);
        return true;
    }


    function UpdateGM( uint _GI, string memory _tokenURI, string memory _GMCID) public onlyMultiSigC  whenLMUsNonActive returns(bool){
        require(!GIC[_GI],"GM GI Y"); // GM for this iteration already avaiable!
        require(_GI==GI+1,"GI IC"); // incorrect GI update!
        require(LMUVDRF[_GI],"LMUVDRF GI X"); //LMUVDRF for _GI not set!
        bool TokenURIsuccessF = IFLNFTC(FLNFTCAddr).assignTokenURI(FLNFTID, _tokenURI);
        bool GMCIDsuccessF = IFLNFTC(FLNFTCAddr).assignGMCID(FLNFTID, _GMCID);
        if(TokenURIsuccessF && GMCIDsuccessF){
            GI = GI+1;
            tokenURI = _tokenURI;
            GMCID = _GMCID;
            emit GMupdated( GI,  _GMCID,  _tokenURI);
            GIC[GI]=true;
            return true;
        } 
        else{
            return false;
        }
    }






}