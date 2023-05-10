// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Product {
        address owner;
        string name;
        string description;
        uint price;
        bool isSold;
    }

    mapping(uint => Product) public products;
    uint public productCount;

    event ProductCreated(uint indexed id, address indexed owner, string name, uint price);
    event ProductSold(uint indexed id, address indexed buyer);

    function createProduct(string memory name, string memory description, uint price) external {
        productCount++;
        products[productCount] = Product(msg.sender, name, description, price, false);
        emit ProductCreated(productCount, msg.sender, name, price);
    }

    function buyProduct(uint id) external payable {
        Product storage product = products[id];
        require(product.isSold == false, "Product has already been sold");
        require(msg.value == product.price, "Incorrect ETH amount");

        product.isSold = true;
        emit ProductSold(id, msg.sender);

        payable(product.owner).transfer(msg.value);
    }
}
