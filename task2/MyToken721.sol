// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Context.sol";


contract MyToken721 is  Context, IERC721, IERC721Metadata {

    using Strings for uint256;

    //名称符号
    string private _name;
    string private _symbol;

    //不可变的地方 核心
    mapping(uint256 tokenId => address) private _owners;
    mapping(address owner => uint256) private _balances;
    //它允许NFT的所有者授权​​另一个地址（操作者）​​ 代表他转移​​某一个特定的NFT​​
    mapping(uint256 tokenId => address) private _tokenApprovals;
    //它允许一个NFT所有者授权​​另一个地址（操作者）​​ 管理他​​所有的NFT​
    mapping(address owner => mapping(address operator => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function _mint(address to, uint256 tokenId) internal {
        if (to == address(0)) {
            revert();
        }
        _update(to, tokenId, address(0));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId
                || interfaceId == type(IERC721Metadata).interfaceId;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function _ownerOf(uint256 tokenId) internal view returns(address) {
        return _owners[tokenId];
    }

    function _requireOwned(uint256 tokenId) internal view returns(address) {
        address owner = _ownerOf(tokenId);
        if (owner == address(0)) {
            revert();
        }
        return owner;
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    //返回一个指向描述该NFT的JSON文件的链接
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        _requireOwned(tokenId);
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString()) : "";
    }

    
    function balanceOf(address owner) external view returns (uint256 balance) {
        if (owner == address(0)) {
            revert();
        }
        return _balances[owner];
    }

    
    function ownerOf(uint256 tokenId) external view returns (address owner) {
        return _requireOwned(tokenId);
    }

   
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        transferFrom(from, to, tokenId);
    }

    
    function safeTransferFrom(address from, address to, uint256 tokenId) public  {
        safeTransferFrom(from, to, tokenId, "");
    }

    
    function transferFrom(address from, address to, uint256 tokenId) public {
        if (to == address(0)) {
            revert();
        }
        address previousOwner = _update(to, tokenId, _msgSender());
        if (previousOwner != from) {
            revert();
        }
    }

    function _update(address to, uint256 tokenId, address auth) internal returns(address) {
        address from = _ownerOf(tokenId);
        //如果提供了授权地址 auth
        if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }
        //这个判断意味着 NFT 是​​已存在的
        if (from != address(0)) {
            //在所有权转移之前，清除这个tokenId的任何单个授权
            //因为所有权即将变更，之前的授权已经毫无意义。这是一个优化操作
           _approve(address(0), tokenId, address(0));
           _balances[from] -= 1;
        }
        if (to != address(0)) {
            _balances[to] += 1;
        }
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        return from;
    }


    function _checkAuthorized(address owner, address spender, uint256 tokenId) internal view {
        if (!_isAuthorized(owner, spender, tokenId)) {
            revert();
        }
    }

    //如果被授权人是作者，或者在被授权列表中
    function _isAuthorized(address owner, address spender, uint256 tokenId) internal view returns(bool) {
        return spender != address(0) 
            && (owner == spender || isApprovedForAll(owner, spender) || _getApproved(tokenId) == spender);
    }

    function _approve(address to, uint256 tokenId, address auth) internal {
        if (auth != address(0)) {
            address owner = _requireOwned(tokenId);
            if (owner != auth && !isApprovedForAll(owner, auth)) {
                revert();
            }
            emit Approval(owner, to, tokenId);
        }
        _tokenApprovals[tokenId] = to;
    }
   
    function approve(address to, uint256 tokenId) external {
        _approve(to, tokenId, _msgSender());
    }

    
    function setApprovalForAll(address operator, bool approved) external {
        if (operator == address(0)) {
            revert();
        }
        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function _getApproved(uint256 tokenId) internal view returns(address operator) {
        return _tokenApprovals[tokenId];
    }

    
    function getApproved(uint256 tokenId) external view returns (address operator) {
         _requireOwned(tokenId);
         return _tokenApprovals[tokenId];
    }

    
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }
}