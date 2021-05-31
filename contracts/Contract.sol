pragma solidity 0.5.16; //1. 여기에 솔리디티 버전 적기

contract ZombieFactory{
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
  }
  //함수란 어떠한 인자값을 받고, 그 값들을 연산하여 결과값을 도출해 내는 것

}

//솔리디티 코드는 컨트랙트 안에 싸여 있지. 컨트랙트는 이더리움 애플리케이션의 기본적인 구성 요소로, 
//모든 변수와 함수는 어느 한 컨트랙트에 속하게 마련이지. 컨트랙트는 자네의 모든 프로젝트의 시작 지점이라고 할 수 있지.