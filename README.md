# Table of Contents
1. [소개](#소개)
2. [팀원소개](#팀원소개)
3. [기능소개](#기능소개)
4. [기술스택](#기술스택)
5. [기술적 의사결정](#기술적-의사결정)
6. [트러블슈팅](#트러블슈팅)
7. [애플 및 유져의 피드백 반영](#애플-및-유져의-피드백-반영)

# 떡볶이4U
<img src="https://img.shields.io/badge/Apple-%23000000.svg?style=for-the-badge&logo=apple&logoColor=white" height="20"> <img src="https://img.shields.io/badge/iOS-16.0%2B-green"> <img src="https://img.shields.io/badge/Library-Combine-FF7043 "> <img src="https://img.shields.io/badge/Library-Firebase-FF7043 "> <img src="https://img.shields.io/badge/Library-KakaoOpenSDK-308C4A "> <img src="https://img.shields.io/badge/Library-ProgressHUD-308C4A "> <img src="https://img.shields.io/badge/Library-SnapKit-308C4A ">

## 소개

![TPK_poster](https://github.com/user-attachments/assets/54c5ef79-f0ab-4ac1-b1c4-0679b651279d)


## 팀원소개
*  **송동익** ([Haroldfromk](https://github.com/haroldfromk))
-  로그인 페이지, 관리자 페이지, 커뮤니티 페이지, 팀 내 Bug Fix, Git 문제 해결
*  **박미림** ([moremirim](https://github.com/moremirim))
-  마이페이지, 리뷰 페이지, 공공 데이터 전처리, UI 보완
*  **박준영** ([labydin](https://github.com/labydin))
-  지도 페이지, 가게 정보 페이지, UI 보완
*  **최진문** ([jinmoon23](https://github.com/jinmoon23))
-  추천 페이지, 에디터 글 작성, 리뷰 이벤트 진행 및 예산 관리


## 기능소개


## 기술스택
- **Environment**

    <img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-github-181717?style=flat&logo=github&logoColor=white"/>

- **Language**

    <img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/> 

- **Collaboration Tool**

    <img src="https://img.shields.io/badge/-slack-4A154B?style=flat&logo=slack&logoColor=white"/> <img src="https://img.shields.io/badge/-notion-000000?style=flat&logo=notion&logoColor=white"/> 


## 기술적 의사결정

## 트러블슈팅

## 애플 및 유져의 피드백 반영


### 유저 테스트 피드백

1. **로그인 페이지**
- 게스트로 로그인 한 후에 `앱을 둘러보다가 로그인 할 수 있는 방법`이 있으면 좋겠습니다.(마이페이지의 프로필을 눌렀을 때, 채팅을 시도했을 때 등등) 현재는 앱을 다시 실행하거나 로그아웃 버튼을 누르고 할 수 있네요!
- **💡 게스트 모드 로그인 개선**
    - 로그인이 필요하다는 Alert가 존재하였으나, 기존에는 확인을 눌렀을때 아무런 변화가 없었음, 이후 피드백을 기반으로 개선을 한 버전에서는 확인을 했을때 로그인 페이지로 자동이동, 취소를 하면 더 기능을 둘러보게끔 변경
    - 마이페이지에서 게스트는 로그아웃이 아니라, 로그인 하러가기로 텍스트를 바꾸면서 세부적인 디테일 수정

2. **추천 페이지**
- `첫 로드가 느린데` 혹시 씬델리게이트에서 먼저 사진을 불러올 수는 없었는지... 런치스크린이 끝나고 로드하는 시간이 또 있어서 앱이 느려보임
- **💡 추천 페이지 개선**
    - 기존에는 모든 내용의 데이터를 가져왔기에 로드하는시간이 오래 걸렸음.
        - 해당부분에 대해 이미지 및 필요한 데이터만 가져오는 최적화 작업 진행
        - 상세 페이지에 들어가면서 데이터를 가져오는 과정이 추가로 생겼으나 Indicator 표시로 유저로 하여금 페이지 로딩 중이라는것을 표시.
    - 세부페이지의 이미지 역시 최적화 작업 진행
    - 해당 부분은 SceneDelegate에서 미리 로드를 한다고 하더라도 기존 코드가 데이터를 전체를 불러오게 되어있기에 크게 의미는 없을 것으로 판단.
        - 물론 데이터를 메모리에 저장후 싱글턴 패턴을 사용한다면 첫 로드 이후에는 데이터를 불러오는데 있어 크게 향상효과를 기대할 수 있음

3. **지도 페이지**
- 지도 화면에 들어섰을때 내 위치는 바로 표시되나 위치를 검색 해야 떡볶이 가게가 표시되고 있어 현재 `내 위치 주변 가게를 바로 보여주는 기능`이 있으면 사용자가 지도탭을 사용했을때 단순히 지도화면이 아닌 검색 후 떡볶이 가게를 알 수 있는 화면이구나 라고 알 수 있을 것 같습니다. (외 1건)
- **💡 지도 페이지 개선**
    - 공공 데이터 기반으로 내 위치 주변 분식집 추가

4. **커뮤니티 페이지**

- 커뮤니티 탭에서 내 지역에서만 채팅이 가능하다고 한다면, **`내 지역을 목록에서 제일 상단에 위치`**했으면 좋겠습니다! (외 1건)
- **💡커뮤니티 채팅 개선**
    - 기존 텍스트 전송만 가능했지만 `사진` 촬영과 라이브러리 및 `지도` 기능 추가가 가능
    - 기존 Date 및 Timestamp 없음 → 유저피드백 참고하여 Date 섹션 및 Timestamp 기능 추가
    - 위치별 Channel(서울특별시, 부산광역시 등) 진입을 사용자 위치 기반으로 파악하여 실사용자 위주의 커뮤니티 환경 구축
    - 현재 사용자 위치의 지역을 제일 상단에 노출, 그리고 현재 지역이라고 추가로 표시

5. **마이페이지**
- 마이페이지의 나의 찜 목록에서 **`북마크와 스크랩한 것들의 내용을 다시 볼 수가 없습니다!`** 스크랩에서는 주소라도 뜨지만, 북마크는 추천 제목(?)만 확인 가능한 것이 아쉽습니다 ㅠㅠ 다시 세부 내용을 보여줬으면 좋겠어요! (외 1건)
- 마이페이지의 공지사항 뒤로가기 버튼과 다른 나의 찜 목록이나 내가 쓴 리뷰 항목의 **`뒤로가기 버튼을 통일`**했으면 좋겠습니다! 지금은 서로 모양이 다르네요! 그리고 나의 찜 목록이나 내가 쓴 리뷰 항목에 다녀왔다가 다시 공지사항에 들어가면 뒤로가기 버튼이 없습니다!
- **💡나의 찜목록 관련 개선**
    - 스크랩 또는 북마크 cell 클릭 시 각각 상세 페이지로 이동 → 북마크와 스크랩 기능 차별화
    - navigationBar 이용해 앱 전체의 back button UI 통일 및 뒤로가기 제스쳐 지원


