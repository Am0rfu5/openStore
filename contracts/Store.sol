pragma solidity ^0.4.18; //We have to specify what version of the compiler this code will use

contract Store {

  // We use the struct datatype to store the voter information.
  struct Media {
    address creator;
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

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  /* When the contract is deployed on the blockchain, we will initialize
   the total number of tokens for sale, cost per token and all the candidates
   */
  function Store(bytes32[] candidateNames1, bytes32[] candidateNames2) public {
    creatorsList = candidateNames1;
    consumersList = candidateNames2;
  }


  function buy(string code) payable public returns(bool success) {
    uint amount = mediaStructs[code].price;
    address receiver = mediaStructs[code].creator;
    if (wallets[msg.sender] < mediaStructs[code].price) return false;
    wallets[msg.sender] -= amount;
    wallets[receiver] += amount;
    Transfer(msg.sender, receiver, amount);
    consumerStructs[msg.sender].consumerMediaList.push(code);
    mediaStructs[code].consumers.push(msg.sender);
    return true;
  }

  function addMedia(string code, bytes32 mname, uint cost) view public returns (bytes32, uint) {
    require(validMedia(code));
    creatorStructs[msg.sender].creatorMediaList.push(code);
    allMedia.push(code);
    mediaStructs[code].creator = msg.sender;
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

  function getMedia(address creatorAddress, uint index, address consumerAddress) view public returns (string, bytes32, uint) {
    string url = creatorStructs[creatorAddress].creatorMediaList[index];
    require(checkMediaForConsumer(url, consumerAddress));
    return (url, mediaStructs[url].title, mediaStructs[url].price);
  }

  function checkMediaForConsumer(string code, address consumerAddress) view public returns (bool) {
    for (uint i = 0; i < consumerStructs[consumerAddress].consumerMediaList.length; i++){
      if (sha3(consumerStructs[consumerAddress].consumerMediaList[i]) == sha3(code)) {
        return true;
      }
    }
    return false;
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
