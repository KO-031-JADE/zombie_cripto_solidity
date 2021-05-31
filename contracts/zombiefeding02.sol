pragma solidity 0.5.16;
//컨트랙트 _상속_이지
//다수의 파일이 있고 어떤 파일을 다른 파일로 불러오고 싶을 때, 솔리디티는 import라는 키워드를 이용하지:
import "./zombiefactory02.sol";

//interface struct랑 차이점이궁금
//블록체인 상에 있으면서 우리가 소유하지 않은 컨트랙트와 우리 컨트랙트가 상호작용을 하려면 우선 인터페이스를 정의해야 하네.
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // `ckAddress`를 이용하여 여기에 kittyContract를 초기화한다
  KittyInterface kittyContract = KittyInterface(ckAddress); //코드를 보면 ckAddress라는 변수에 크립토키티 컨트랙트 주소가 입력되어 있다. 다음 줄에 kittyContract라는 KittyInterface를 생성하고, ckAddress를 이용하여 초기화한다.

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public { //feedAndMultiply라는 함수를 생성한다. 이 함수는 uint형인 _zombieId 및 _targetDna을 전달받는다. 이 함수는 public으로 선언되어야 한다.
    require(msg.sender == zombieToOwner[_zombieId]); //다른 누군가가 우리 좀비에게 먹이를 주는 것을 원치 않는다. 그러므로 주인만이 좀비에게 먹이를 줄 수 있도록 한다. require 구문을 추가하여 msg.sender가 좀비 주인과 동일하도록 한다. (이는 createRandomZombie 함수에서 쓰인 방법과 동일하다)
    Zombie storage myZombie = zombies[_zombieId]; //먹이를 먹는 좀비 DNA를 얻을 필요가 있으므로, 그 다음으로 myZombie라는 Zombie형 변수를 선언한다 (이는 storage 포인터가 될 것이다). 이 변수에 zombies 배열의 _zombieId 인덱스가 가진 값에 부여한다.
    
    _targetDna = _targetDna % dnaModulus;//먼저, _targetDna가 16자리보다 크지 않도록 해야 한다. 이를 위해, _targetDna를 _targetDna % dnaModulus와 같도록 해서 마지막 16자리 수만 취하도록 한다.
    uint newDna = (myZombie.dna + _targetDna) / 2; //그 다음, 함수가 newDna라는 uint를 선언하고 myZombie의 DNA와 _targetDna의 평균 값을 부여해야 한다.
    
    if(keccak256(_species) == keccak256("kutty")){
       newDna = newDna - newDna % 100 + 99;
    }
    
    _createZombie("NoName", newDna); //새로운 DNA 값을 얻게 되면 _createZombie 함수를 호출한다. 이 함수를 호출하는 데 필요한 인자 값을 zombiefactory.sol 탭에서 확인할 수 있다. 참고로, 이 함수는 좀비의 이름을 인자 값으로 필요로 한다. 그러니 새로운 좀비의 이름을 현재로서는 "NoName"으로 하도록 하자. 나중에 좀비 이름을 변경하는 함수를 작성할 수 있을 것이다.
  }
  function feedOnKitty(uint _zombieId, uint _kittyId) public{
    uint kittyDna;// 이 함수는 kittyDna라는 uint를 먼저 선언해야 한다.
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);// 그 다음, 이 함수는 _kittyID를 전달하여 kittyContract.getKitty 함수를 호출하고 genes을 kittyDna에 저장해야 한다.getKitty가 다수의 변수를 반환한다는 사실을 기억할 것 (정확히 말하자면 10개의 변수를 반환한다). 하지만 우리가 관심 있는 변수는 마지막 변수인 genes이다. 쉼표 수를 유심히 세어 보기 바란다!
    feedAndMultiply(_zombieId, kittyDna, "kitty"); //마지막으로 이 함수는 feedAndMultiply를 호출하고 이 때 _zombieId와 kittyDna를 전달해야 한다.
  }
}

//솔리디티에는 변수를 저장할 수 있는 공간으로 storage와 memory 두 가지가 있지.
// Storage는 블록체인 상에 영구적으로 저장되는 변수를 의미하지. 
// Memory는 임시적으로 저장되는 변수로, 컨트랙트 함수에 대한 외부 호출들이 일어나는 사이에 지워지지. 두 변수는 각각 컴퓨터 하드 디스크와 RAM과 같지.

