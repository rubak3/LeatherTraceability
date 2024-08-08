//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Registration.sol";

contract HFACCertification {
    
    Registration immutable regSC;
    
    address immutable owner;

    mapping (address=>bool) public certifiedSlaughterhouses;

    constructor(address regSCAddress) {
        owner = msg.sender;
        regSC = Registration(regSCAddress);
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegistered() {
        require(regSC.Slaughterhouses(msg.sender), "Only registered slaughterhouses can call this function");
        _;
    }
    
    event SlaughterhouseRequestedHFACCertification(address slaughterhouseAddress, bytes32 IPFShash);
    event SlaughterhouseCertificationApproved(address slaughterhouseAddress, uint validationPeriod);
    event SlaughterhouseCertificationDenied(address slaughterhouseAddress);
    event SlaughterhouseCertificationRevoked(address slaughterhouseAddress);
    event SlaughterhouseAuditsRequested(address slaughterhouseAddress);
    event SlaughterhouseAuditsSubmitted(address slaughterhouseAddress, bytes32 IPFShash);

    function reqHFACCertification(bytes32 IPFShash) public onlyRegistered(){
        require(!certifiedSlaughterhouses[msg.sender], "Slaughterhouse is already certified");
        emit SlaughterhouseRequestedHFACCertification(msg.sender, IPFShash);
    }

    function approveCertification(address slaughterhouseAddress, uint validationPeriod) public onlyOwner {
        certifiedSlaughterhouses[slaughterhouseAddress] = true;
        emit SlaughterhouseCertificationApproved(slaughterhouseAddress, validationPeriod);
    }

    function denyCertification(address slaughterhouseAddress) public onlyOwner {
        emit SlaughterhouseCertificationDenied(slaughterhouseAddress);
    }

    function submitAudits(bytes32 IPFShash) public onlyRegistered(){
        emit SlaughterhouseAuditsSubmitted(msg.sender, IPFShash);
    }

    function revokeCertification(address slaughterhouseAddress) public onlyOwner {
        require(certifiedSlaughterhouses[slaughterhouseAddress], "Slaughterhouse is not certified");
        delete certifiedSlaughterhouses[slaughterhouseAddress];
        emit SlaughterhouseCertificationRevoked(slaughterhouseAddress);
    }

    function reqAudits(address slaughterhouseAddress) public onlyOwner {
        emit SlaughterhouseAuditsRequested(slaughterhouseAddress);
    }

}


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Registration.sol";

contract LWGCertification {
    
    Registration immutable regSC;
    
    address immutable owner;

    mapping (address=>bool) public certifiedTanneries;

    constructor(address regSCAddress) {
        owner = msg.sender;
        regSC = Registration(regSCAddress);
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegistered() {
        require(regSC.Tanneries(msg.sender), "Only registered tanneries can call this function");
        _;
    }
    
    event TanneryRequestedLWGCertification(address tanneryAddress, bytes32 IPFShash);
    event TanneryCertificationApproved(address tanneryAddress, uint validationPeriod);
    event TanneryCertificationDenied(address tanneryAddress);
    event TanneryCertificationRevoked(address tanneryAddress);
    event TanneryAuditsRequested(address tanneryAddress);
    event TanneryAuditsSubmitted(address tanneryAddress, bytes32 IPFShash);

    function reqLWGCertification(bytes32 IPFShash) public onlyRegistered(){
        require(!certifiedTanneries[msg.sender], "Tannery is already certified");
        emit TanneryRequestedLWGCertification(msg.sender, IPFShash);
    }

    function approveCertification(address tanneryAddress, uint validationPeriod) public onlyOwner {
        certifiedTanneries[tanneryAddress] = true;
        emit TanneryCertificationApproved(tanneryAddress, validationPeriod);
    }

    function denyCertification(address tanneryAddress) public onlyOwner {
        emit TanneryCertificationDenied(tanneryAddress);
    }

    function submitAudits(bytes32 IPFShash) public onlyRegistered(){
        emit TanneryAuditsSubmitted(msg.sender, IPFShash);
    }

    function revokeCertification(address tanneryAddress) public onlyOwner {
        require(certifiedTanneries[tanneryAddress], "Tannery is not certified");
        delete certifiedTanneries[tanneryAddress];
        emit TanneryCertificationRevoked(tanneryAddress);
    }

    function reqAudits(address tanneryAddress) public onlyOwner {
        emit TanneryAuditsRequested(tanneryAddress);
    }

}


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Registration.sol";

contract OEKOTEXCertification {
    
    Registration immutable regSC;
    
    address immutable owner;

    mapping (address=>bool) public certifiedManufacturers;

    constructor(address regSCAddress) {
        owner = msg.sender;
        regSC = Registration(regSCAddress);
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegistered() {
        require(regSC.Manufacturers(msg.sender), "Only registered manufacturers can call this function");
        _;
    }
    
    event ManufacturerRequestedOEKOTEXCertification(address manufacturerAddress, bytes32 IPFShash);
    event ManufacturerCertificationApproved(address manufacturerAddress, uint validationPeriod);
    event ManufacturerCertificationDenied(address manufacturerAddress);
    event ManufacturerCertificationRevoked(address manufacturerAddress);
    event ManufacturerAuditsRequested(address manufacturerAddress);
    event ManufacturerAuditsSubmitted(address manufacturerAddress, bytes32 hash);

    function reqOEKOTEXCertification(bytes32 IPFShash) public onlyRegistered(){
        require(!certifiedManufacturers[msg.sender], "Manufacturer is already certified");
        emit ManufacturerRequestedOEKOTEXCertification(msg.sender, IPFShash);
    }

    function approveCertification(address manufacturerAddress, uint validationPeriod) public onlyOwner {
        certifiedManufacturers[manufacturerAddress] = true;
        emit ManufacturerCertificationApproved(manufacturerAddress, validationPeriod);
    }

    function denyCertification(address manufacturerAddress) public onlyOwner {
        emit ManufacturerCertificationDenied(manufacturerAddress);
    }

    function submitAudits(bytes32 IPFShash) public onlyRegistered(){
        emit ManufacturerAuditsSubmitted(msg.sender, IPFShash);
    }

    function revokeCertification(address manufacturerAddress) public onlyOwner {
        require(certifiedManufacturers[manufacturerAddress], "Manufacturer is not certified");
        delete certifiedManufacturers[manufacturerAddress];
        emit ManufacturerCertificationRevoked(manufacturerAddress);
    }

    function reqAudits(address manufacturerAddress) public onlyOwner {
        emit ManufacturerAuditsRequested(manufacturerAddress);
    }

}
