// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { EnumerableSetExtra } from "./util/EnumerableSetExtra.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
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
contract MultiSigC is Ownable{
    
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSetExtra for EnumerableSet.AddressSet;
    using EnumerableSetExtra for EnumerableSet.UintSet;

    address payable public DAOFLCAddr;
    address payable public ODAOMTCAddr;

    bool public createFLNFTf=false;

    Counters.Counter private _ProposalId;

    enum ProposalState {
        NotExist, // Default state (0) for nonexistent proposals
        Open, // Proposal can receive approvals
        Executable, // Proposal has received required number of approvals
        Closed, // Proposal is closed
        Executed // Proposal has been executed
    }

    struct Proposal {
        ProposalState state;
        bytes4 selector;
        bytes argumentData;
        // Addresses of accounts that have submitted approvals
        EnumerableSet.AddressSet approvals;
    }

    struct ContractCallType {
        
        Configuration config;
        // IDs of open proposals for this type of contract call
        EnumerableSet.UintSet openProposals;

        uint256 numOpenProposals;
        
    }


    struct Configuration {
        string configName;
        // Maximum number of open proposals per approver - if exceeded, the
        // approvers has to close or execute an existing open proposal to be able
        // to create another proposal.
        uint256 maxOpenProposals;
    }

    /**
     * @dev Preconfigured contract call types:
     * Function selector => ContractCallType
     */
    mapping(bytes4 => ContractCallType) private _types;
    bytes4[] private _typeKeys;

    /**
     * @dev Proposals: Proposal ID => Proposal
     */
    mapping(uint256 => Proposal) private _proposals;

    uint public GI = 0;

    /**
     * @dev Proposals: Proposal ID => pGI
     */
    mapping(uint256 => uint256) private pGI;
    /**
     * @dev Proposals: Proposal ID => tokenURI
     */
    mapping(uint256 => string) private tokenURIs;
    /**
     * @dev Proposals: Proposal ID => GMCID
     */
    mapping(uint256 => string) private GMCIDs;

    /**
     * @dev GI => selector => bool
     */
    
    mapping(uint256 => mapping (bytes4 => bool)) public executionf;  //proposal id => aelector => executionf


    event createFLNFTpCreated(uint256 indexed id, string _tokenURI,  string _GMipfsHash);
    event UpdateGMpCreated(uint256 indexed id, uint256 indexed pGI, string _tokenURI,  string _GMipfsHash);
    event ProposalCreated(uint256 indexed id, string name, uint256 indexed pGI);
    event ProposalClosed(uint256 indexed id, string name);
    event ProposalApprovalSubmitted(
        uint256 indexed id,
        address indexed approver,
        string name, 
        uint256 numApprovals,
        uint256 minApprovals
    );
    event ProposalExecutable(
        uint256 indexed id,
        string name
    );
    event ProposalExecuted(uint256 indexed id, string name);

        /**
     * @notice Ensure that the proposal is open
     * @param proposalId    Proposal ID
     */
    modifier proposalIsOpen(uint256 proposalId, bool executable) {
        ProposalState state = _proposals[proposalId].state;
        if(!executable)
            require(state == ProposalState.Open, "MultiSigC: proposal is not open");
        else
            require(state == ProposalState.Open || state == ProposalState.Executable, "MultiSigC: proposal is not open");
        _;
    }

        /**
     * @notice Ensure that the proposal is open
     * @param proposalId    Proposal ID
     */
    modifier proposalIsExecutable(uint256 proposalId) {
        ProposalState state = _proposals[proposalId].state;
        require(
                state == ProposalState.Executable,
            "MultiSigC: proposal is not Executable"
        );
        _;
    }

    modifier onlyODAOM(){
        require(IDAOMTC(ODAOMTCAddr).balanceOf(_msgSender()) == 1, "MultiSigC:caller is not ODAO member");
        _;
    }

    constructor (address payable _DAOFLCAddr, address payable _ODAOMTCAddr) {
        DAOFLCAddr = _DAOFLCAddr;
        ODAOMTCAddr = _ODAOMTCAddr;

        ContractCallType storage callType1 = _types[bytes4(keccak256("createFLNFT(string,string)"))];
        _typeKeys.push(bytes4(keccak256("createFLNFT(string,string)")));
        Configuration storage config1 = callType1.config;
        config1.configName = "createFLNFT";
        config1.maxOpenProposals = 3;

        ContractCallType storage callType2 = _types[bytes4(keccak256("Initiate_LMUs(uint256)"))];
        _typeKeys.push(bytes4(keccak256("Initiate_LMUs(uint256)")));
        Configuration storage config2 = callType2.config;
        config2.configName = "Initiate_LMUs";
        config2.maxOpenProposals = 1;

        ContractCallType storage callType3 = _types[bytes4(keccak256("Cease_LMUs(uint256)"))];
        _typeKeys.push(bytes4(keccak256("Cease_LMUs(uint256)")));
        Configuration storage config3 = callType3.config;
        config3.configName = "Cease_LMUs";
        config3.maxOpenProposals = 1;

        ContractCallType storage callType4 = _types[bytes4(keccak256("setLMUVDRF(uint256)"))];
        _typeKeys.push(bytes4(keccak256("setLMUVDRF(uint256)")));
        Configuration storage config4 = callType4.config;
        config4.configName = "setLMUVDRF";
        config4.maxOpenProposals = 1;

        ContractCallType storage callType5 = _types[bytes4(keccak256("UpdateGM(uint256,string,string)"))];
        _typeKeys.push(bytes4(keccak256("UpdateGM(uint256,string,string)")));
        Configuration storage config5 = callType5.config;
        config5.configName = "UpdateGM";
        config5.maxOpenProposals = 3;
    }
    
    function transferOwnership(address newOwner) public onlyOwner { 
        require(newOwner != address(0), "NOWN0"); //Ownable: new owner is the zero address
        _transferOwnership(newOwner);
    }

    function contains(bytes4[] memory arr, bytes4 selector) internal pure returns (bool) {
    for (uint i = 0; i < arr.length; i++) {
        if (arr[i] == selector) {
            return true;
        }
    }
    return false;
}

    // Function to get all the keys in the mapping.
    function getSelectors() public view returns (bytes4[] memory) {
        return _typeKeys;
    }

    /**
     * @notice Propose a contract call
     * @dev Emits the proposal ID in ProposalCreated event.
     * @return Proposal ID
     */
    function proposecreateFLNFT(
        string memory _tokenURI, string memory _GMCID
    )
        external
        onlyOwner
        returns (uint256)
    {
        require(!createFLNFTf,"createFLNFT already executed");
        bytes4 selector = bytes4(keccak256("createFLNFT(string,string)"));
        bytes memory argumentData = abi.encode(_tokenURI, _GMCID);
        uint256 proposalID = _propose(selector, argumentData);

        if(proposalID>0){
            
            emit createFLNFTpCreated(proposalID, _tokenURI,  _GMCID);
            pGI[proposalID]=0;
            tokenURIs[proposalID]=_tokenURI;
            GMCIDs[proposalID]=_GMCID;
        }

        return proposalID;
    }

    /**
     * @notice Propose a contract call
     * @dev Emits the proposal ID in ProposalCreated event.
     * @return Proposal ID
     */
    function proposeUpdateGM(
        uint _pGI, string memory _tokenURI, string memory _GMCID
    )
        external
        onlyOwner
        returns (uint256)
    {
        require(createFLNFTf,"execute createFLNFT first");
        require(_pGI==GI,"given GI not valid");
        require(executionf[GI][bytes4(keccak256("setLMUVDRF(uint256)"))],"execute setLMUVDRF first");
        bytes4 selector = bytes4(keccak256("UpdateGM(uint256,string,string)"));
        bytes memory argumentData = abi.encode(_pGI,_tokenURI, _GMCID);
        uint256 proposalID = _propose(selector, argumentData);
        if(proposalID>0){
            
            emit UpdateGMpCreated(proposalID, _pGI, _tokenURI,  _GMCID);
            pGI[proposalID]=_pGI;
            tokenURIs[proposalID]=_tokenURI;
            GMCIDs[proposalID]=_GMCID;
        }
        return proposalID;
    }

        /**
     * @notice Propose a contract call
     * @dev Emits the proposal ID in ProposalCreated event.
     * @return Proposal ID
     */
    function propose(
        bytes4 selector, uint _pGI
    )
        external
        onlyOwner
        returns (uint256)
    {
        require(createFLNFTf,"execute createFLNFT first");
        require(_pGI==GI,"given GI not valid");
        require(selector!=bytes4(keccak256("createFLNFT(string,string)")) && selector!=bytes4(keccak256("UpdateGM(uint256,string,string)")),"given selector not valid here" );
        require(contains(_typeKeys, selector),"given selector not valid");
        require(!executionf[GI][selector],"selector already executed for current GI");
        
        if(selector==bytes4(keccak256("Cease_LMUs(uint256)"))){
            require(executionf[GI][bytes4(keccak256("Initiate_LMUs(uint256)"))],"execute Initiate_LMUs first");
        }

        if(selector==bytes4(keccak256("setLMUVDRF(uint256)"))){
            require(executionf[GI][bytes4(keccak256("Cease_LMUs(uint256)"))],"execute Cease_LMUs first");
        }
        

        bytes memory argumentData = abi.encode(_pGI);

        uint256 proposalID = _propose(selector, argumentData);
        string memory _configName = _types[selector].config.configName;
        if(proposalID>0){
            emit ProposalCreated(proposalID, _configName, _pGI);
            pGI[proposalID]=_pGI;
        }
        return proposalID;
    }


        /**
     * @notice Private function to create a new proposal
     * @param selector          Selector of the function in the contract
     * @param argumentData      ABI-encoded argument data
     * @return Proposal ID
     */
    function _propose(
        bytes4 selector,
        bytes memory argumentData
    ) private returns (uint256) {
        require(contains(_typeKeys, selector),"given selector not valid");

        ContractCallType storage callType = _types[selector];
        uint256 numOpenProposals = callType.numOpenProposals;
        require(
            numOpenProposals < callType.config.maxOpenProposals,
            "MultiSigC: Maximum open proposal limit reached"
        );
        _ProposalId.increment();
        uint256 proposalId = _ProposalId.current();

        Proposal storage proposal = _proposals[proposalId];
        proposal.state = ProposalState.Open;
        proposal.selector = selector;
        proposal.argumentData = argumentData;

        // Increment open proposal count 
        callType.numOpenProposals = numOpenProposals+1;

        // Add proposal ID to the set of open proposals
        callType.openProposals.add(proposalId);

        return proposalId;
    }

    /**
     * @notice Close a proposal without executing
     * @dev This can only be called by the proposer.
     * @param proposalId    Proposal
     */
    function closeProposal(uint256 proposalId)
        external
        proposalIsOpen(proposalId, true)
        onlyOwner
    {
        require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        _closeProposal(proposalId);
    }

    /**
     * @notice Private function to close a proposal
     * @param proposalId    Proposal ID
     */
    function _closeProposal(uint256 proposalId) private {
        require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        Proposal storage proposal = _proposals[proposalId];

        // Update state to Closed
        proposal.state = ProposalState.Closed;

        ContractCallType storage callType = _types[proposal.selector];

        // Remove proposal from openProposals
        callType.openProposals.remove(proposalId);
        callType.numOpenProposals = callType
            .numOpenProposals-1;
        string memory _configName = _types[proposal.selector].config.configName;
        emit ProposalClosed(proposalId,_configName);
    }

        /**
     * @notice Submit an approval for a proposal
     * @dev Only the approvers for the type of contract call specified in the
     * proposal are able to submit approvals.
     * @param proposalId    Proposal ID
     */
    function approve(uint256 proposalId)
        external
        proposalIsOpen(proposalId, false)
        onlyODAOM
    {
        require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        _approve(msg.sender, proposalId);
    }


     /**
     * @notice Private function to add an approval to a proposal
     * @param approver      Approver's address
     * @param proposalId    Proposal ID
     */
    function _approve(address approver, uint256 proposalId) private {
        Proposal storage proposal = _proposals[proposalId];
        EnumerableSet.AddressSet storage approvals = proposal.approvals;
        require(pGI[proposalId]==GI,"can not approve proposal,pGI invalid");
        require(
            !approvals.contains(approver),
            "MultiSigC: caller has already approved the proposal"
        );
        address[] memory toRemove = new address[](approvals.length());
        uint removeIndex = 0;
        for (uint i = 0; i < approvals.length(); i++) {
            address element = approvals.at(i);
            // Check if the element satisfies the criteria
            if (IDAOMTC(ODAOMTCAddr).balanceOf(element)!=1) {
                // Add the element to the list of elements to remove
                toRemove[removeIndex] = element;
                removeIndex++;
            } 
        }

        // Remove the elements that didn't satisfy the criteria
        for (uint i = 0; i < removeIndex; i++) {
            approvals.remove(toRemove[i]);
        }



        approvals.add(approver);

        uint256 numApprovals = proposal.approvals.length();
        uint256 minApprovals =  IDAOMTC(ODAOMTCAddr).totalSupply()*60/100; 

        string memory _configName = _types[proposal.selector].config.configName;

        emit ProposalApprovalSubmitted(
            proposalId,
            approver,
            _configName,
            numApprovals,
            minApprovals
        );

        // if the required number of approvals is met, mark it as executable
        if (numApprovals > minApprovals) {
            proposal.state = ProposalState.Executable;
            emit ProposalExecutable(proposalId,_configName);
        }
    }

    /**
     * @notice Execute an approved proposal
     * @dev Required number of approvals must have been met; only the approvers
     * for a given type of contract call proposed are able to execute.
     * @param proposalId    Proposal ID
     * @return Return data from the contract call
     */
    function execute(uint256 proposalId)
        external
        payable
        proposalIsExecutable(proposalId)
        onlyOwner
        returns (bytes memory)
    {
        require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        return _execute(proposalId);
    }

    /**
     * @notice Private function to execute a proposal
     * @dev Before calling this function, be sure that the state of the proposal
     * is Open.
     * @param proposalId    Proposal ID
     */
    function _execute(uint256 proposalId)
        private
        returns (bytes memory)
    {   require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        Proposal storage proposal = _proposals[proposalId];
        address targetContract = DAOFLCAddr;
        require(pGI[proposalId]==GI,"can not execute proposal,pGI invalid");
        
        require(
            Address.isContract(targetContract),
            "MultiSigC: targetContract is not a contract"
        );
        bytes4 selector = proposal.selector;

        if(selector==bytes4(keccak256("createFLNFT(string,string)"))){
            require(!executionf[0][bytes4(keccak256("createFLNFT(string,string))"))],"createFLNFT already executed");
        }
            
        if(selector==bytes4(keccak256("Initiate_LMUs(uint256)"))){
            require(!executionf[GI][bytes4(keccak256("Initiate_LMUs(uint256)"))],"Initiate_LMUs already executed");
        }

        else if(selector==bytes4(keccak256("Cease_LMUs(uint256)"))){
            require(!executionf[GI][bytes4(keccak256("Cease_LMUs(uint256)"))],"Cease_LMUs already executed" );
        }

        else if(selector==bytes4(keccak256("setLMUVDRF(uint256)"))){
            require(!executionf[GI][bytes4(keccak256("setLMUVDRF(uint256)"))],"setLMUVDRF already executed" );
        }
        

        
        ContractCallType storage callType = _types[selector];

        bool success;
        bytes memory returnData;

        
        (success, returnData) = targetContract.call{ value: msg.value }(
            abi.encodePacked(selector, proposal.argumentData)
        );
        

        if (!success) {
            string memory err = "MultiSigC: call failed";

            // Return data will be at least 100 bytes if it contains the reason
            // string: Error(string) selector[4] + string offset[32] + string
            // length[32] + string data[32] = 100
            if (returnData.length < 100) {
                revert(err);
            }

            // If the reason string exists, extract it, and bubble it up
            string memory reason;
            assembly {
                // Skip over the bytes length[32] + Error(string) selector[4] +
                // string offset[32] = 68 (0x44)
                reason := add(returnData, 0x44)
            }

            revert(string(abi.encodePacked(err, ": ", reason)));
        }
        else{

            // Remove the proposal ID from openProposals
            callType.openProposals.remove(proposalId);
            callType.numOpenProposals = callType
                .numOpenProposals-1;
            // Mark the proposal as executed
            proposal.state = ProposalState.Executed;
            string memory _configName = _types[selector].config.configName;
            emit ProposalExecuted(proposalId, _configName);
            executionf[GI][selector]=true;
            if(selector==bytes4(keccak256("createFLNFT(string,string)")) || selector==bytes4(keccak256("UpdateGM(uint256,string,string)"))){
                GI=GI+1;
            }

            if(selector==bytes4(keccak256("createFLNFT(string,string)")) ){
                createFLNFTf=true;
            }

            

        }

        return returnData;
    }

    function getProposal(uint256 proposalId) public view returns (
        ProposalState,
        bytes4, //selector of proposal
        string memory,
        bytes memory ,
        address[] memory,
        uint256,
        uint256,
        uint256,
        string memory,
        string memory
    ){
        require(proposalId!=0 && proposalId<=_ProposalId.current(), "proposalId not valid");
        Proposal storage proposal = _proposals[proposalId];
        string memory uri="";
        string memory gmCID="";


        uint256 numApprovals = EnumerableSet.length(proposal.approvals);
        address[] memory approvalsArray = new address[](numApprovals);
        for (uint256 i = 0; i < numApprovals; i++) {
            approvalsArray[i] = EnumerableSet.at(proposal.approvals, i);
        }
        if(proposal.selector==bytes4(keccak256("createFLNFT(string,string)")) || proposal.selector==bytes4(keccak256("UpdateGM(uint256,string,string)"))){
            uri=tokenURIs[proposalId];
            gmCID=GMCIDs[proposalId];
        }
        return (
        proposal.state, //state of proposal
        proposal.selector, //selector of proposal
         _types[proposal.selector].config.configName, //configName of proposal
        proposal.argumentData, 
        approvalsArray, // address of those who approve this proposal
        pGI[proposalId], //  GI if exist
        numApprovals, // current approvals
        IDAOMTC(ODAOMTCAddr).totalSupply()*60/100, // required approvals if not approved yet
        uri, // uri if applicable
        gmCID
        );
    }

    function getConfigNamebySelector(bytes4 selector) public view returns( string memory){
        return _types[selector].config.configName;
        
    }

}