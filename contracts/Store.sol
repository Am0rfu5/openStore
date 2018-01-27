pragma solidity ^0.4.18; //We have to specify what version of the compiler this code will use

contract Store {

  // We use the struct datatype to store the voter information.
  struct Media {
    bytes32 title;
    uint price;
    address[] consumers;
  }

  struct Creator {
    string[] creatorMediaList;
  }

  struct Consumer {
    string[] consumerMediaList;
  }

  string[] allMedia;

  mapping (address => uint) public wallets;
  mapping (string => Media) mediaStructs;
  mapping (address => Creator) creatorStructs;
  mapping (address => Consumer) consumerStructs;
  bytes32[] public creatorsList;
  bytes32[] public consumersList;

  /* When the contract is deployed on the blockchain, we will initialize
   the total number of tokens for sale, cost per token and all the candidates
   */
  function Store(bytes32[] candidateNames1, bytes32[] candidateNames2) public {
    creatorsList = candidateNames1;
    consumersList = candidateNames2;
  }

/*
  function buy(bytes32 code) payable public {
    uint req_cost;
    uint i;
    bytes32 hashcode;
    for(i = 0; i < creatorStructs[creatorAddress].creatorMediaList.length; i++) {
      hashcode = creatorStructs[creatorAddress].creatorMediaList[i];
      if (creatorStructs[creatorAddress].mediaStructs[hashcode].title == mname) {
        req_cost = creatorStructs[creatorAddress].mediaStructs[hashcode].price;
        break;
      }
    }
    require(req_cost == cost);
    creatorStructs[creatorAddress].mediaStructs[hashcode].audience.push(msg.sender);
    wallets[creatorAddress] += cost;
    // return wallets[creatorAddress];
  }
  */

  function addMedia(string code, bytes32 mname, uint cost) view public returns (bytes32, uint) {
    require(validMedia(code));
    creatorStructs[msg.sender].creatorMediaList.push(code);
    allMedia.push(code);
    mediaStructs[code].title = mname;
    mediaStructs[code].price = cost;
    return (mediaStructs[code].title, mediaStructs[code].price);
  }

  function allCreators() view public returns (bytes32[]) {
    return creatorsList;
  }

  function allConsumers() view public returns (bytes32[]) {
    return consumersList;
  }

  function getWallet(address creatorAddress) view public returns (uint) {
    return wallets[creatorAddress];
  }

  function getMedia(address creatorAddress, uint index) view public returns (string, bytes32, uint) {
    string url = creatorStructs[creatorAddress].creatorMediaList[index];
    return (url, mediaStructs[url].title, mediaStructs[url].price);
  }

  function getMediaCount(address creatorAddress) view public returns (uint) {
    return creatorStructs[creatorAddress].creatorMediaList.length;
  }

  function validMedia(string code) view public returns (bool) {
    for(uint i = 0; i < allMedia.length; i++) {
      if (sha3(allMedia[i]) == sha3(code)){
        return false;
      }
    }
    return true;
  }

}
