// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

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
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
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

contract DRDCAnima is ERC165, IERC721, Ownable {
    string tokenName = "Anima";
    string tokenSymbol = "DRDCA";

    struct Anima {
        string dna;
        uint256 timeAlive;
        uint256 timeLastTrain;
    }

    Anima[] animas;

    address validBirther;

    bytes4 _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 _INTERFACE_ID_ERC721 = 0x80ac58cd;

    string public baseURI;
    uint256 public price = 0;

    mapping(uint256 => address) internal animaToOwner;
    mapping(address => uint256) internal ownerAnimaCount;
    mapping(uint256 => address) public animaToApproved;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    modifier onlyValidBirther() {
        require(msg.sender == validBirther);
        _;
    }

    modifier notZeroAddress(address _address) {
        require(_address != address(0), "zero address");
        _;
    }

    modifier validAnimaId(uint256 _animaId) {
        require(_animaId < animas.length, "invalid anima id");
        _;
    }

    modifier onlyAnimaOwner(uint256 _animaId) {
        require(isAnimaOwner(_animaId), "sender not anima owner");
        _;
    }

    modifier onlyApproved(uint256 _animaId) {
        require(
            isAnimaOwner(_animaId) ||
            isApproved(_animaId) ||
            isApprovedOperatorOf(_animaId),
            "sender not anima owner OR approved"
        );
        _;
    }

    event Birth(address owner, uint256 animaId, string dna);

    constructor() {
        // unknown anima
        animas.push(Anima({
            dna: "0",
            timeAlive: block.timestamp,
            timeLastTrain: block.timestamp
        }));
        setBaseURI("");
    }

    function _baseURI() internal view returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public virtual onlyOwner {
        baseURI = _newBaseURI;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerAnimaCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view validAnimaId(_tokenId) returns (address){
        return _ownerOf(_tokenId);
    }

    function _ownerOf(uint256 _tokenId) internal view returns (address ) {
        return animaToOwner[_tokenId];
    }

    function isAnimaOwner(uint256 _animaId) public view returns (bool) {
        return msg.sender == _ownerOf(_animaId);
    }

    function totalSupply() external view returns (uint256) {
        return animas.length - 1;
    }

    function name() external view returns (string memory) {
        return tokenName;
    }

    function symbol() external view returns (string memory) {
        return tokenSymbol;
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165) 
        returns (bool)
    {
        return (_interfaceId == _INTERFACE_ID_ERC165 ||
            _interfaceId == _INTERFACE_ID_ERC721);
    }

    function transfer(address _to, uint256 _tokenId) external onlyApproved(_tokenId) notZeroAddress(_to) {
        require(_to != address(this), "to contract address");

        _transfer(msg.sender, _to, _tokenId);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        if (_from != address(0)) {
            ownerAnimaCount[_from] = ownerAnimaCount[_from] - 1;
        }

        ownerAnimaCount[_to] = ownerAnimaCount[_to] + 1;

        animaToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public onlyApproved(_tokenId) {
        animaToApproved[_tokenId] = _approved;

        emit Approval(msg.sender, _approved, _tokenId);
    }

    function isApproved(uint256 _animaId) public view returns (bool) {
        return msg.sender == animaToApproved[_animaId];
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorApprovals[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view validAnimaId(_tokenId) returns (address) {
        return animaToApproved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _isApprovedForAll(_owner, _operator);
    }

    function _isApprovedForAll(address _owner, address _operator) internal view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function isApprovedOperatorOf(uint256 _animaId) public view returns (bool) {
        return _isApprovedForAll(animaToOwner[_animaId], msg.sender);
    }

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal {
        _transfer(_from, _to, _tokenId);
        require(_checkERC721Support(_from, _to, _tokenId, _data));
    }

    function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if (_isContract(_to)) {
            try IERC721Receiver(_to).onERC721Received(_msgSender(), _from, _tokenId, _data) returns (bytes4 retval) {
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

    function _isContract(address _to) internal view returns (bool) {
        // wallets will not have any code but contract must have some code
        uint32 size;
        assembly {
            size := extcodesize(_to)
        }
        return size > 0;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external onlyApproved(_tokenId) notZeroAddress(_to) {
        require(_from == _ownerOf(_tokenId), "from address not anima owner");
        _safeTransfer(_from, _to, _tokenId, _data);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external onlyApproved(_tokenId) notZeroAddress(_to) {
        require(_from == _ownerOf(_tokenId), "from address not anima owner");
        _safeTransfer(_from, _to, _tokenId, bytes(""));
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external onlyApproved(_tokenId) notZeroAddress(_to) {
        require(
            _from == animaToOwner[_tokenId],
            "from address not anima owner"
        );
        _transfer(_from, _to, _tokenId);
    }

    function getAnima(uint256 _animaId) external view returns(
        string memory dna,
        uint256 timeAlive,
        uint256 timeLastTrain
    ) {
        Anima storage a = animas[_animaId];
        dna = a.dna;
        timeAlive = a.timeAlive;
        timeLastTrain = a.timeLastTrain;
    }

    function birthAnima(string memory _dna, address _owner) public onlyValidBirther returns(uint256) {
        return _birth(_owner, _dna);
    }

    function _birth(address _owner, string memory _dna) private returns (uint256) {
        Anima memory a = Anima({
            dna: _dna,
            timeAlive: block.timestamp,
            timeLastTrain: block.timestamp
        });

        animas.push(a);
        uint256 newAnimaId = animas.length - 1;
        animaToOwner[newAnimaId] = _owner;

        _transfer(address(0), _owner, newAnimaId);
        
        emit Birth(_owner, newAnimaId, _dna);

        return newAnimaId;
    }

    function setValidBirther(address _birther) external onlyOwner {
        validBirther = _birther;
    }

    function updateAnima(uint256 _animaId, string memory _dna, bool _didTrain) external onlyValidBirther {
        Anima storage a = animas[_animaId];
        a.dna = _dna;
        if(_didTrain) {
            a.timeLastTrain = block.timestamp;
        }
    }
}
