## 목차
1. [uikit-uber-clone](#uikit-uber-clone)
2. [구현 내용](#구현-내용)
3. [사용한 라이브러리 및 프레임 워크](#사용한-라이브러리-및-프레임-워크)
4. [Results](#Results)
5. [Structure](#Structure)
6. [Coverage](#Coverage)


# uikit-uber-clone

iOS15 UIKit 을 활용해서 Uber 앱을 클론한다. 

## 구현 내용

- 실시간 유저 위치 구독
- 실시간 운전 요청
- 실시간 운전 요청 취소
- 실시간 운전 완료
- 인증

## 사용한 라이브러리 및 프레임 워크
- [MapKit](https://developer.apple.com/documentation/mapkit/)
- [Firebase](https://firebase.google.com/?hl=ko)
  - Geofire
  - Firestore
  - Realtime Database
- [SnapKit](https://github.com/SnapKit/SnapKit)
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [KDCircularProgress](https://github.com/kaandedeoglu/KDCircularProgress)
- [SideMenu](https://github.com/jonkykong/SideMenu)
- [Combine](https://developer.apple.com/documentation/combine)

## Results

- 회원가입 <br /><br />
<img src="https://user-images.githubusercontent.com/34573243/147393368-cead4911-6849-449f-9678-27dcda56a142.png" width=500 /> <br/><br />

- [동영상 보러가기](https://www.youtube.com/watch?v=bWDMQPn1Zbs)

[<img width="500" alt="스크린샷 2022-01-04 오후 7 18 25" src="https://user-images.githubusercontent.com/34573243/148044342-4517edb0-75e4-49c3-be35-7582ab66c13e.png">](https://www.youtube.com/watch?v=bWDMQPn1Zbs)

## Structure
```
├── uikit-uber-clone
│   ├── Assets.xcassets - Color, Image 등 에셋파일
│   ├── color - 백그라운드, 폰트 등 색상       
│   ├── constant - 상수 저장       
│   ├── controller - Controller 를 화면 단위로 구분(View와 비슷하지만 페이지의 개념으로 사용)      
│   │   ├── auth
│   │   ├── main
│   │   ├── menu
│   │   └── splash
│   ├── delegate
│   ├── di - Repository, Util, ViewController, ViewModel 단위로 DI 구분      
│   ├── enum
│   ├── error
│   ├── extension
│   ├── model
│   ├── repository - 데이터를 가지고 오는 곳
│   ├── storyboards
│   ├── util
│   ├── view
│   │   ├── auth
│   │   ├── global
│   │   └── main - Controller 내에 들어가는 View. Component의 개념. 
│   │       ├── RequestLoadingView.swift
│   │       ├── bottomSheet
│   │       ├── locationInput
│   │       └── matched
│   └── viewmodel - View의 상태를 추상화한 viewmodel  
│       ├── BaseViewModel.swift
│       ├── UserViewModel.swift
│       ├── auth
│       ├── main
│       │   ├── locationInput
│       │   ├── matched
│       │   └── pickup
│       ├── menu
│       └── splash
└── uikit-uber-cloneTests - Unit 테스트 프로젝트
```

## Coverage
<img width="600" alt="스크린샷 2022-01-04 오후 8 23 59" src="https://user-images.githubusercontent.com/34573243/148052166-bf5103ae-1b1f-41cf-b245-fe28b0cdbea6.png">

