//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Registration.sol";
import "Certifications.sol";

contract Traceability {

    Registration immutable regSC;
    HFACCertification immutable hfacCertSC;
    LWGCertification immutable lwgCertSC;
    OEKOTEXCertification immutable otCertSC;

    address immutable owner;

    struct Cattle {
        address farmAddress;
        uint256 price;
        bool authorized;
        bool sold;
        address slaughterhouseAddress;
    }

    struct Hide {
        address slaughterhouseAddress;
        uint256 price;
        bool authorized;
        bool sold;
        address cattleAddress;
        address tanneryAddress;
    }

    struct Leather {
        address tanneryAddress;
        uint256 price;
        bool authorized;
        bool sold;
        address hideAddress;
        address manufacturerAddress;
    }

    struct FinishedProduct {
        address manufacturerAddress;
        uint256 price;
        bool authorized;
        bool sold;
        address leatherAddress;
        address retailerAddress;
    }

    struct FinalLeatherProduct {
        address retailerAddress;
        uint256 price;
        bool authorized;
        bool sold;
        address finProdAddress;
    }

    mapping (address=>Cattle) public cattle;
    mapping (address=>Hide) public hides;
    mapping (address=>Leather) public leathers;
    mapping (address=>FinishedProduct) public finProds;
    mapping (address=>FinalLeatherProduct) public leatherProds;

    constructor(address regSCAddr, address hfacSCAddr, address lwgSCAddr, address otSCAddr) {
        owner = msg.sender;
        regSC = Registration(regSCAddr);
        hfacCertSC = HFACCertification(hfacSCAddr);
        lwgCertSC = LWGCertification(lwgSCAddr);
        otCertSC = OEKOTEXCertification(otSCAddr);
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegFarms(address a) {
        require(regSC.Farms(a), "Farm is not registered");
        _;
    }

    modifier onlyRegSlaughterhouses(address a) {
        require(regSC.Slaughterhouses(a), "Slaughterhouse is not registered");
        _;
    }

    modifier onlyRegTanneries(address a) {
        require(regSC.Tanneries(a), "Tannery is not registered");
        _;
    }

    modifier onlyRegManufacturers(address a) {
        require(regSC.Manufacturers(a), "Manufacturer is not registered");
        _;
    }

    modifier onlyRegRetailers(address a) {
        require(regSC.Retailers(a), "Retailer is not registered");
        _;
    }
    
    event SCAuthorizedToSellCattle(address farm, address cattle, uint256 size);
    event SCAuthorizedToSellHides(address slaughterhouse, address hides, uint256 size);
    event SCAuthorizedToSellLeathers(address tannery, address leathers, uint256 size);
    event SCAuthorizedToSellFinishedProducts(address manufacturer, address finProds, uint256 size);
    event SCAuthorizedToSellLeatherProducts(address retailer, address leatherProds, uint256 size);

    event CattleSoldToSlaughterhouse(address slaughterhouse, address farm, address cattle);
    event HidesSoldToTannery(address tannery, address slaughterhouse, address hides);
    event LeathersSoldToManufacturer(address manufacturer, address tannery, address leathers);
    event FinishedProductsSoldToRetailer(address retailer, address manufacturer, address finProds);
    event LeatherProductsSoldToConsumer(address retailer, address leatherProds);

    function authorizeSellingCattle(uint256 price, address _cattle, uint256 size) public onlyRegFarms(msg.sender) {
        require(!cattle[_cattle].authorized, "Already authorized to sell this cattle");
        cattle[_cattle].farmAddress = msg.sender;
        cattle[_cattle].price = price;
        cattle[_cattle].authorized = true;
        emit SCAuthorizedToSellCattle(msg.sender, _cattle, size);
    }

    function buyCattle(address payable farm, address _cattle) public payable onlyRegSlaughterhouses(msg.sender) {
        require(hfacCertSC.certifiedSlaughterhouses(msg.sender), "Slaughterhouse is not certified");
        require(cattle[_cattle].authorized && !cattle[_cattle].sold, "This cattle is unavailable");
        require(farm==cattle[_cattle].farmAddress, "Farm address is not correct");
        require(msg.value==cattle[_cattle].price * 1 ether, "Ether amount does not match the price");
        cattle[_cattle].slaughterhouseAddress = msg.sender;
        cattle[_cattle].sold = true;
        farm.transfer(cattle[_cattle].price * 1 ether);
        emit CattleSoldToSlaughterhouse(msg.sender, farm, _cattle);
    }

    function authorizeSellingHides(uint256 price, address hideAddr, address cattleAddr, uint256 size) public onlyRegSlaughterhouses(msg.sender) {
        require(hfacCertSC.certifiedSlaughterhouses(msg.sender), "Slaughterhouse is not certified");
        require(!hides[hideAddr].authorized, "Already authorized to sell this hide");
        require(cattle[cattleAddr].slaughterhouseAddress==msg.sender, "Cattle address is not correct");
        hides[hideAddr].slaughterhouseAddress = msg.sender;
        hides[hideAddr].price = price;
        hides[hideAddr].authorized = true;
        hides[hideAddr].cattleAddress = cattleAddr;
        emit SCAuthorizedToSellHides(msg.sender, hideAddr, size);
    }

    function buyHides(address payable slaughterhouse, address hideAddr) public payable onlyRegTanneries(msg.sender) {
        require(lwgCertSC.certifiedTanneries(msg.sender), "Tannery is not certified");
        require(hides[hideAddr].authorized && !hides[hideAddr].sold, "This hides lot is unavailable");
        require(slaughterhouse==hides[hideAddr].slaughterhouseAddress, "Slaughterhouse address is not correct");
        require(msg.value==hides[hideAddr].price * 1 ether, "Ether amount does not match the price");
        hides[hideAddr].tanneryAddress = msg.sender;
        hides[hideAddr].sold = true;
        slaughterhouse.transfer(hides[hideAddr].price * 1 ether);
        emit HidesSoldToTannery(msg.sender, slaughterhouse, hideAddr);
    }

    function authorizeSellingLeathers(uint256 price, address leatherAddr, address hideAddr, uint256 size) public onlyRegTanneries(msg.sender) {
        require(lwgCertSC.certifiedTanneries(msg.sender), "Tannery is not certified");
        require(!leathers[leatherAddr].authorized, "Already authorized to sell this leather");
        require(hides[hideAddr].tanneryAddress==msg.sender, "Hides lot address is not correct");
        leathers[leatherAddr].tanneryAddress = msg.sender;
        leathers[leatherAddr].price = price;
        leathers[leatherAddr].authorized = true;
        leathers[leatherAddr].hideAddress = hideAddr;
        emit SCAuthorizedToSellLeathers(msg.sender, leatherAddr, size);
    }

    function buyLeathers(address payable tannery, address leatherAddr) public payable onlyRegManufacturers(msg.sender) {
        require(otCertSC.certifiedManufacturers(msg.sender), "Manufacturer is not certified");
        require(leathers[leatherAddr].authorized && !leathers[leatherAddr].sold, "This leathers lot is unavailable");
        require(tannery==leathers[leatherAddr].tanneryAddress, "Tannery address is not correct");
        require(msg.value==leathers[leatherAddr].price * 1 ether, "Ether amount does not match the price");
        leathers[leatherAddr].manufacturerAddress = msg.sender;
        leathers[leatherAddr].sold = true;
        tannery.transfer(leathers[leatherAddr].price * 1 ether);
        emit LeathersSoldToManufacturer(msg.sender, tannery, leatherAddr);
    }

    function authorizeSellingFinProds(uint256 price, address finProdAddr, address leatherAddr, uint256 size) public onlyRegManufacturers(msg.sender) {
        require(otCertSC.certifiedManufacturers(msg.sender), "Manufacturer is not certified");
        require(!finProds[finProdAddr].authorized, "Already authorized to sell this product");
        require(leathers[leatherAddr].manufacturerAddress==msg.sender, "Leathers lot address is not correct");
        finProds[finProdAddr].manufacturerAddress = msg.sender;
        finProds[finProdAddr].price = price;
        finProds[finProdAddr].authorized = true;
        finProds[finProdAddr].leatherAddress = leatherAddr;
        emit SCAuthorizedToSellFinishedProducts(msg.sender, finProdAddr, size);
    }

    function buyFinProds(address payable manufacturer, address finProdAddr) public payable onlyRegRetailers(msg.sender) {
        require(finProds[finProdAddr].authorized && !finProds[finProdAddr].sold, "This finished products lot is unavailable");
        require(manufacturer==finProds[finProdAddr].manufacturerAddress, "Manufacturer address is not correct");
        require(msg.value==finProds[finProdAddr].price * 1 ether, "Ether amount does not match the price");
        finProds[finProdAddr].retailerAddress = msg.sender;
        finProds[finProdAddr].sold = true;
        manufacturer.transfer(finProds[finProdAddr].price * 1 ether);
        emit FinishedProductsSoldToRetailer(msg.sender, manufacturer, finProdAddr);
    }

    function authorizeSellingLeatherProds(uint256 price, address leatherProdAddr, address finProdAddr, uint256 size) public onlyRegRetailers(msg.sender) {
        require(!leatherProds[leatherProdAddr].authorized, "Already authorized to sell this product");
        require(finProds[finProdAddr].retailerAddress==msg.sender, "Finished products lot address is not correct");
        leatherProds[leatherProdAddr].retailerAddress = msg.sender;
        leatherProds[leatherProdAddr].price = price;
        leatherProds[leatherProdAddr].authorized = true;
        leatherProds[leatherProdAddr].finProdAddress = finProdAddr;
        emit SCAuthorizedToSellLeatherProducts(msg.sender, leatherProdAddr, size);
    }

    function buyLeatherProds(address payable retailer, address leatherProdAddr) public payable {
        require(leatherProds[leatherProdAddr].authorized && !leatherProds[leatherProdAddr].sold, "This product is unavailable");
        require(retailer==leatherProds[leatherProdAddr].retailerAddress, "Retailer address is not correct");
        require(msg.value==leatherProds[leatherProdAddr].price * 1 ether, "Ether amount does not match the price");
        leatherProds[leatherProdAddr].sold = true;
        require(msg.sender != address(0));
        retailer.transfer(leatherProds[leatherProdAddr].price * 1 ether);
        emit LeatherProductsSoldToConsumer(retailer, leatherProdAddr);
    }

}
