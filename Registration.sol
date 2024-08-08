//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract Registration {

    address immutable owner;

    mapping (address=>bool) public Farms;
    mapping (address=>bool) public Slaughterhouses;
    mapping (address=>bool) public Tanneries;
    mapping (address=>bool) public Manufacturers;
    mapping (address=>bool) public Retailers;

    constructor () {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Only owner can call this function");
        _;
    }

    event FarmRequestedToRegister(address Farm, bytes32 IPFSHash);
    event SlaughterhouseRequestedToRegister(address Slaughterhouse, bytes32 IPFSHash);
    event TanneryRequestedToRegister(address Tannery, bytes32 IPFSHash);
    event ManufacturerRequestedToRegister(address Manufacturer, bytes32 IPFSHash);
    event RetailerRequestedToRegister(address Retailer, bytes32 IPFSHash);

    event FarmRegistrationRequestApproved(address Farm);
    event SlaughterhouseRegistrationRequestApproved(address Slaughterhouse);
    event TanneryRegistrationRequestApproved(address Tannery);
    event ManufacturerRegistrationRequestApproved(address Manufacturer);
    event RetailerRegistrationRequestApproved(address Retailer);

    event FarmRegistrationRequestDenied(address Farm);
    event SlaughterhouseRegistrationRequestDenied(address Slaughterhouse);
    event TanneryRegistrationRequestDenied(address stakeholder);
    event ManufacturerRegistrationRequestDenied(address Tannery);
    event RetailerRegistrationRequestDenied(address Manufacturer);

    function farmRegistrationReq(bytes32 IPFSHash) public {
        require(!Farms[msg.sender], "Farm is already registered");
        emit FarmRequestedToRegister(msg.sender, IPFSHash);
    }

    function slaughterhouseRegistrationReq(bytes32 IPFSHash) public {
        require(!Slaughterhouses[msg.sender], "Slaughterhouse is already registered");
        emit SlaughterhouseRequestedToRegister(msg.sender, IPFSHash);
    }

    function tanneryRegistrationReq(bytes32 IPFSHash) public {
        require(!Tanneries[msg.sender], "Tannery is already registered");
        emit TanneryRequestedToRegister(msg.sender, IPFSHash);
    }

    function manufacturerRegistrationReq(bytes32 IPFSHash) public {
        require(!Manufacturers[msg.sender], "Manufacturer is already registered");
        emit ManufacturerRequestedToRegister(msg.sender, IPFSHash);
    }

    function retailerRegistrationReq(bytes32 IPFSHash) public {
        require(!Retailers[msg.sender], "Retailer is already registered");
        emit RetailerRequestedToRegister(msg.sender, IPFSHash);
    }
    
    function approveFarmReg(address stakeholder) public onlyOwner {
        Farms[stakeholder] = true;
        emit FarmRegistrationRequestApproved(stakeholder);
    }

    function approveSlaughterhouseReg(address stakeholder) public onlyOwner {
        Slaughterhouses[stakeholder] = true;
        emit SlaughterhouseRegistrationRequestApproved(stakeholder);
    }

    function approveTanneryReg(address stakeholder) public onlyOwner {
        Tanneries[stakeholder] = true;
        emit TanneryRegistrationRequestApproved(stakeholder);
    }

    function approveManufacturerReg(address stakeholder) public onlyOwner {
        Manufacturers[stakeholder] = true;
        emit ManufacturerRegistrationRequestApproved(stakeholder);
    }

    function approveRetailerReg(address stakeholder) public onlyOwner {
        Retailers[stakeholder] = true;
        emit RetailerRegistrationRequestApproved(stakeholder);
    }

    function denyFarmReg(address stakeholder) public onlyOwner {
        delete Farms[stakeholder];
        emit FarmRegistrationRequestDenied(stakeholder);
    }

    function denySlaughterhouseReg(address stakeholder) public onlyOwner {
        delete Slaughterhouses[stakeholder];
        emit SlaughterhouseRegistrationRequestDenied(stakeholder);
    }

    function denyTanneryReg(address stakeholder) public onlyOwner {
        delete Tanneries[stakeholder];
        emit TanneryRegistrationRequestDenied(stakeholder);
    }

    function denyManufacturerReg(address stakeholder) public onlyOwner {
        delete Manufacturers[stakeholder];
        emit ManufacturerRegistrationRequestDenied(stakeholder);
    }

    function denyRetailerReg(address stakeholder) public onlyOwner {
        delete Retailers[stakeholder];
        emit RetailerRegistrationRequestDenied(stakeholder);
    }

}
