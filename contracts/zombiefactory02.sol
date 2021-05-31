pragma solidity 0.5.16;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
    
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // 여기서 시작
        // 솔리디티에는 모든 함수에서 이용 가능한 특정 전역 변수들이 있지. 
        // 그 중의 하나가 현재 함수를 호출한 사람 (혹은 스마트 컨트랙트)의 주소를 가리키는 msg.sender이지.
        // msg.sender를 활용하면 자네는 이더리움 블록체인의 보안성을 이용할 수 있게 되지. 
        // 즉, 누군가 다른 사람의 데이터를 변경하려면 해당 이더리움 주소와 관련된 개인키를 훔치는 것 밖에는 다른 방법이 없다는 것이네.
        zombieToOwner[id] = msg.sender; //먼저, 새로운 좀비의 id가 반환된 후에 zombieToOwner 매핑을 업데이트하여 id에 대하여 msg.sender가 저장되도록 해보자.
        ownerZombieCount[msg.sender]++; //그 다음, 저장된 msg.sender을 고려하여 ownerZombieCount를 증가시키자.
        NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
      require(ownerZombieCount[msg.sender] == 0);//require를 활용하면 특정 조건이 참이 아닐 때 함수가 에러 메시지를 발생하고 실행을 멈추게 되지:
      //그러므로 require는 함수를 실행하기 전에 참이어야 하는 특정 조건을 확인하는 데 있어서 꽤 유용하지.
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
//주소 address
// 이더리움 블록체인은 은행 계좌와 같은 계정들로 이루어져 있지. 계정은 이더리움 블록체인상의 통화인 _이더_의 잔액을 가지지.
// 자네의 은행 계좌에서 다른 계좌로 돈을 송금할 수 있듯이, 계정을 통해 다른 계정과 이더를 주고 받을 수 있지.

//매핍 mapping
//레슨 1에서 구조체와 _배열_을 살펴 봤네. _매핑_은 솔리디티에서 구조화된 데이터를 저장하는 또다른 방법이지.
// 매핑은 기본적으로 키-값 (key-value) 저장소로, 데이터를 저장하고 검색하는 데 이용된다.
// // 금융 앱용으로, 유저의 계좌 잔액을 보유하는 uint를 저장한다: 
// mapping (address => uint) public accountBalance;
// // 혹은 userID로 유저 이름을 저장/검색하는 데 매핑을 쓸 수도 있다 
// mapping (uint => string) userIdToName;
// 첫번째 예시에서 키는 address이고 값은 uint이다. 두번째 예시에서 키는 uint이고 값은 string이다.

//함수 접근 제어자 
//public과 private 이외에도 솔리디티에는 internal과 external이라는 함수 접근 제어자가 있지.
//internal은 함수가 정의된 컨트랙트를 상속하는 컨트랙트에서도 접근이 가능하다 점을 제외하면 private과 동일하지
//external은 함수가 컨트랙트 바깥에서만 호출될 수 있고 컨트랙트 내의 다른 함수에 의해 호출될 수 없다는 점을 제외하면 public과 동일하지.