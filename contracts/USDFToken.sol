pragma solidity ^0.4.18;

import "./StandardTokenWithFees.sol";
import "./Pausable.sol";
import "./BlackList.sol";

contract UpgradedStandardToken is StandardToken {
    // those methods are called by the legacy contract
    // and they must ensure msg.sender to be the contract address
    uint256 public _totalSupply;

    function transferByLegacy(
        address from,
        address to,
        uint256 value
    ) public returns (bool);

    function transferFromByLegacy(
        address sender,
        address from,
        address spender,
        uint256 value
    ) public returns (bool);

    function approveByLegacy(
        address from,
        address spender,
        uint256 value
    ) public returns (bool);

    function increaseApprovalByLegacy(
        address from,
        address spender,
        uint256 addedValue
    ) public returns (bool);

    function decreaseApprovalByLegacy(
        address from,
        address spender,
        uint256 subtractedValue
    ) public returns (bool);
}

contract USDFToken is Pausable, StandardTokenWithFees, BlackList {
    address public upgradedAddress;
    bool public deprecated;
    mapping(address => bool) whilelist;

    //  The contract can be initialized with a number of tokens
    //  All the tokens are deposited to the owner address
    //
    // @param _balance Initial supply of the contract
    // @param _name Token Name
    // @param _symbol Token symbol
    // @param _decimals Token decimals
    constructor() public {
        _totalSupply = 0;
        name = "USDF Token";
        symbol = "USDF";
        decimals = 6;
        balances[owner] = 0;
        deprecated = false;
        whilelist[owner]=true;
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transfer(address _to, uint256 _value)
        public
        whenNotPaused
        returns (bool)
    {
        require(!isBlackListed[msg.sender]);
        if (deprecated) {
            return
                UpgradedStandardToken(upgradedAddress).transferByLegacy(
                    msg.sender,
                    _to,
                    _value
                );
        } else {
            return super.transfer(_to, _value);
        }
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public whenNotPaused returns (bool) {
        require(!isBlackListed[_from]);
        if (deprecated) {
            return
                UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
                    msg.sender,
                    _from,
                    _to,
                    _value
                );
        } else {
            return super.transferFrom(_from, _to, _value);
        }
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function balanceOf(address who) public constant returns (uint256) {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).balanceOf(who);
        } else {
            return super.balanceOf(who);
        }
    }

    // Allow checks of balance at time of deprecation
    function oldBalanceOf(address who) public constant returns (uint256) {
        if (deprecated) {
            return super.balanceOf(who);
        }
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function approve(address _spender, uint256 _value)
        public
        whenNotPaused
        returns (bool)
    {
        if (deprecated) {
            return
                UpgradedStandardToken(upgradedAddress).approveByLegacy(
                    msg.sender,
                    _spender,
                    _value
                );
        } else {
            return super.approve(_spender, _value);
        }
    }

    function increaseApproval(address _spender, uint256 _addedValue)
        public
        whenNotPaused
        returns (bool)
    {
        if (deprecated) {
            return
                UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(
                    msg.sender,
                    _spender,
                    _addedValue
                );
        } else {
            return super.increaseApproval(_spender, _addedValue);
        }
    }

    function decreaseApproval(address _spender, uint256 _subtractedValue)
        public
        whenNotPaused
        returns (bool)
    {
        if (deprecated) {
            return
                UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(
                    msg.sender,
                    _spender,
                    _subtractedValue
                );
        } else {
            return super.decreaseApproval(_spender, _subtractedValue);
        }
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function allowance(address _owner, address _spender)
        public
        constant
        returns (uint256 remaining)
    {
        if (deprecated) {
            return StandardToken(upgradedAddress).allowance(_owner, _spender);
        } else {
            return super.allowance(_owner, _spender);
        }
    }

    // deprecate current contract in favour of a new one
    function deprecate(address _upgradedAddress) public onlyOwner {
        require(_upgradedAddress != address(0));
        deprecated = true;
        upgradedAddress = _upgradedAddress;
        emit Deprecate(_upgradedAddress);
    }

    // deprecate current contract if favour of a new one
    function totalSupply() public constant returns (uint256) {
        if (deprecated) {
            return StandardToken(upgradedAddress).totalSupply();
        } else {
            return _totalSupply;
        }
    }

    function addWhileList(address user) external onlyOwner {
        whilelist[user] = true;
    }

    function deleteWhileList(address user) external onlyOwner {
        whilelist[user] = false;
    }

    modifier onlyWhileList(address user) {
        require(whilelist[user] == true, "Not in whilelist");
        _;
    }

    // Issue a new amount of tokens
    // these tokens are deposited into the "to" address
    //
    // @param _amount Number of tokens to be issued
    function issue(address to, uint256 amount) public onlyWhileList(msg.sender)  {
        require(amount != 0);
        balances[to] = balances[to].add(amount);
        _totalSupply = _totalSupply.add(amount);
        emit Issue(to, amount, block.timestamp);
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) public onlyWhileList(msg.sender)  {
        require(amount != 0);
        require(amount <= balances[from]);
        balances[from] = balances[from].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Burn(from, amount, block.timestamp);
        emit Transfer(from, address(0), amount);
    }

    // Redeem tokens.
    // These tokens are withdrawn from the owner address
    // if the balance must be enough to cover the redeem
    // or the call will fail.
    // @param _amount Number of tokens to be issued
    function redeem(uint256 amount) public onlyWhileList(msg.sender) {
        _totalSupply = _totalSupply.sub(amount);
        balances[owner] = balances[owner].sub(amount);
        emit Redeem(amount);
        emit Transfer(owner, address(0), amount);
    }

    function destroyBlackFunds(address _blackListedUser) public onlyWhileList(msg.sender)  {
        require(isBlackListed[_blackListedUser]);
        uint256 dirtyFunds = balanceOf(_blackListedUser);
        balances[_blackListedUser] = 0;
        _totalSupply = _totalSupply.sub(dirtyFunds);
        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
    }

    event DestroyedBlackFunds(
        address indexed _blackListedUser,
        uint256 _balance
    );

    // Called when new token are issued
    event Issue(address to, uint256 amount, uint256 time);

    // Called when tokens are burned
    event Burn(address from, uint256 amount, uint256 time);

    // Called when tokens are redeemed
    event Redeem(uint256 amount);

    // Called when contract is deprecated
    event Deprecate(address newAddress);
}
