pragma solidity 0.5.16; //1. 여기에 솔리디티 버전 적기

contract ZombieFactory{
  event NewZombie (uint zobieId, string name, uint dna);
  // 이벤트는 자네의 컨트랙트가 블록체인 상에서 자네 앱의 사용자 단에서 무언가 액션이 발생했을 때
  // 의사소통하는 방법이지. 컨트랙트는 특정 이벤트가 일어나는지 "귀를 기울이고" 그 이벤트가 발생하면 행동을 취하지.

  uint dnaDigits = 16; //상태변수는 블록체인 안에 영구적으로 저장이된다
  uint dnaModulus = 10 ** dnaDigits; //// 즉, 10^16  10의 16승
  // uint = unsigned integer 음수가 아닌 부호없는 정수
  // 참고: 솔리디티에서 uint는 실제로 uint256, 즉 256비트 부호 없는 정수의 다른 표현이지.

  struct Zombie{
    string name;
    uint dna;
  }
  //struct 즉 구조체를 이용하면 복잡한 구조와 변수가 심플해 집니다.

  Zombie[] public zombies;
  //* 배열
  //2개의 원소를 담을 수 있는 고정 길이의 배열
  //uint[2] fixedArray;

  //또다른 고정 배열으로 5개의 스트링을 담을 수 있다;
  //string[5] stringArray;

  //동적 배열은 고정된 크기가 없으며 계속 크기가 커질 수 있다
  //uint[] dynamicArray;

  //public 배열
  // public으로 배열을 선언할 수 있지. 솔리디티는 이런 배열을 위해 getter 메소드를 자동적으로 생성하지. 구문은 다음과 같네:
  // 그러면 다른 컨트랙트들이 이 배열을 읽을 수 있게 되지 (쓸 수는 없네). 이는 컨트랙트에 공개 데이터를 저장할 때 유용한 패턴이지.

  function _createZombie(string _name, uint _dna) private{
    //private 선언된 함수는 관례로 _를 추가 해야한다
    zombies.push(Zombie(_name, _dna));

    uint id = zombies.push(Zombie(_name, _dna)) - 1;
    NewZombie(id, _name, _dna);
  }
  //함수란 어떠한 인자값을 받고, 그 값들을 연산하여 결과값을 도출해 내는 것
  function _generateRandomDna(string _str) private view returns(uint){
  //view함수로 선언하는 것은 상태를 변화시키지 않거나 어떤값을 변경하거나 무언가를 쓰지 않을떄 선언한다

    uint rand = uint(keccak256(_str)); // _str을 해시값을 받아 난수 16진수를 생성하고 uint로 형변환 한다음 rand라는 uint에 결과값을 저장
    return rand % dnaModulus;//16자리 숫자만을 원하므로 dnaModulus 코드의 결과값을 모듈로 연산한 값을 반환한다
  }

  function createRandomZombie(string _name) public{
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
    // createRandomZombie라는 public함수를 생성한다. 이 함수는 _name이라는 string형 인자를 하나 전달받는다. (참고: 함수를 private로 선언한 것과 마찬가지로 함수를 public로 생성할 것)
    // 이 함수의 첫 줄에서는 _name을 전달받은 _generateRandomDna 함수를 호출하고, 이 함수의 반환값을 randDna라는 uint형 변수에 저장해야 한다.
    // 두번째 줄에서는 _createZombie 함수를 호출하고 이 함수에 _name와 randDna를 전달해야 한다.
    // 함수의 내용을 닫는 }를 포함해서 코드가 4줄이어야 한다.
  }
}

//솔리디티 코드는 컨트랙트 안에 싸여 있지. 컨트랙트는 이더리움 애플리케이션의 기본적인 구성 요소로, 
//모든 변수와 함수는 어느 한 컨트랙트에 속하게 마련이지. 컨트랙트는 자네의 모든 프로젝트의 시작 지점이라고 할 수 있지.