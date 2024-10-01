# Table of Contents
1. [소개](#소개)
2. [팀원소개](#팀원소개)
3. [기능소개](#기능소개)
4. [기술스택](#기술스택)
5. [기술적 의사결정](#기술적-의사결정)
6. [트러블슈팅](#트러블슈팅)
7. [애플 및 유져의 피드백 반영](#애플-및-유져의-피드백-반영)

# 떡볶이4U
<img src="https://img.shields.io/badge/Apple-%23000000.svg?style=for-the-badge&logo=apple&logoColor=white" height="20"> <img src="https://img.shields.io/badge/iOS-16.0%2B-green"> <img src="https://img.shields.io/badge/Library-Combine-FF7043 "> <img src="https://img.shields.io/badge/Library-Firebase-FF7043 "> <img src="https://img.shields.io/badge/Library-KakaoOpenSDK-308C4A "> <img src="https://img.shields.io/badge/Library-SkeletonView-308C4A ">
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

---

| **범위** | **기술 이름** |
| --- | --- |
| 의존성 관리 도구 | **`SPM`** |
| 버전 관리 | **`GitHub`, `Git`** |
| 아키텍처 | **`MVVM`, `MVC`** |
| 디자인 패턴 | **`Delegate`, `Observer`**  |
| 인터페이스 | **`UIKit`, `MapKit`, `MessageKit`, `Combine`, `SkeletonView`, `VerticalCardSwiper`** |
| 레이아웃 | **`SnapKit`** |
| 코드, 깃 컨벤션 | [**`SA`**](https://www.notion.so/85e238a4e20e4d00a8e94121d5ad153d?pvs=21) |
| 데이터베이스 | **`Userdefaults`, `FirebaseDatabase` , `FirebaseFirestore`** |
| 외부 라이브러리 | **`Kingfisher`, `ProgressHUD`, `YPImagePicker`, `SwiftJWT`, `GoogleSignin`, `FirebaseStorage`, `FirebaseAuth`**  |
| API | **`Kakao Local API`** |

## 기술적 의사결정

<details>
<summary>1. Architecture</summary>

**MVVM**

- UI 로직과 비즈니스 로직을 분리하여 가독성 향상
- Combine 도입
    - Firebase의 데이터의 **`변화를 감지`**하여 필요한 변경사항을 **`즉각 적용`**

</details>

<details>
<summary>2. 매커니즘 회의</summary>

- 커뮤니티 입장 시 닉네임 설정에 관한 메커니즘 회의  
    ![CleanShot 2024-07-03 at 00.35.25@2x.png](%5B%E1%84%84%E1%85%A5%E1%86%A8%E1%84%87%E1%85%A9%E1%86%A9%E1%84%8B%E1%85%B54U%5D%20-%20%E1%84%8B%E1%85%AE%E1%84%85%E1%85%B5%E1%84%80%E1%85%A1%20%E1%84%86%E1%85%A1%E1%86%AB%E1%84%83%E1%85%B3%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%87%E1%85%AE%E1%86%AB%E1%84%89%E1%85%B5%E1%86%A8%20%E1%84%8C%E1%85%B5%E1%84%83%E1%85%A9%20(1)%20871cca0c88be4121916f39751b24cdb5/CleanShot_2024-07-03_at_00.35.252x.png)

</details>

<details>
<summary>3. Firebase</summary>

> **✅ 전체 데이터의 Firebase 관리**

- 데이터 모델링  
    ![데이터 모델링 이미지](이미지 경로)

- **💡 Firebase**
    - (선택 이유) 이용자들 간 **`상호작용`**이 많은 커뮤니티 앱 특성 상 서버 기반 Database 선택
        - 다른 유저의 가게 리뷰 보기
        - 실시간 채팅 기능
    - 유저 관리, 추천 페이지, 공지사항 등 **`서버 기반 관리 가능`**

</details>

<details>
<summary>4. 코드 일관성과 협업 효율성을 위한 전역 변수 및 공통 함수 사용</summary>

- Firebase의 Field 입력 실수 방지를 위한 전역 변수 관리  
    ```swift
    let noticeCollection = Firestore.firestore().collection("notice")
    let db_uid = "uid"
    ```

- Team Color 및 Font 전역 변수로 설정  
    ```swift
    static let mainOrange = UIColor(hexString: "FE724C")
    static func fontELight(size: CGFloat = 18) -> UIFont { 
        UIFont(name: "Pretendard-ExtraLight", size: size)! 
    }
    ```

- 반복되는 Alert창에 대해 통일된 함수 사용  
    ```swift
    showMessage
    showMessageWithCancel
    ```

</details>

## 트러블슈팅

<details>
<summary>1. 로그인 페이지</summary>

### 🛠 트러블 & 해결과정 🔧

#### 🚧 트러블:
- 로그인을 할 때 **Completion Handler** 사용으로 인해 단발성 로그인만 가능한 문제가 발생.

#### ✅ 해결과정:
- `PassthroughSubject<Result<Void, Error>, Never>()`으로 수정하여 에러와 성공 상태를 처리.
- `PassthroughSubject<Void, Error>()`의 리턴 타입에서 에러 처리 및 Completion 발생 문제를 해결하고, 이후 로그인 재시도가 가능하도록 변경.
    
</details>

<details>
<summary>2. 추천 페이지</summary>

### 🛠 트러블 & 해결과정 🔧

#### 🚧 트러블 1:
- **문제**: FB 데이터를 불필요하게 쌓아 무작위로 CardView가 표시되는 문제 발생.

#### ✅ 해결과정:
- FB order 필드를 추가하여 정렬하고, `fetch` 시 `removeAll`로 데이터 중복 문제 해결.

---

#### 🚧 트러블 2:
- **문제**: 페이지 재진입 시 모든 CardCell에 대해 Fetch를 다시 실행하는 문제.

#### ✅ 해결과정:
- 불필요한 코드를 제거하여 Fetch 중복을 방지하고, 북마크 동기화 기능은 유지.

---

#### 🚧 트러블 3:
- **문제**: 모든 데이터를 한 번에 로드해 첫 화면 로딩 시간이 길어짐.

#### ✅ 해결과정:
- 필요한 데이터부터 우선적으로 로드하여 화면 표시 시간을 단축, 상세 페이지에서 이미지를 빠르게 로드하도록 구현.
    
</details>

<details>
<summary>3. 지도 페이지</summary>

### 🛠 트러블 & 해결과정 🔧

#### 🚧 트러블:
- background에서 foreground로 전환 시 **custom annotation** 이미지가 보이지 않는 문제 발생.

#### ✅ 해결과정:
- `Notification`과 `UIApplication.willEnterForegroundNotification`을 사용해 foreground 전환 시 이미지를 업데이트하도록 구현.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
        
    NotificationCenter.default.addObserver(self, 
        selector: #selector(appWillEnterForeground), 
        name: UIApplication.willEnterForegroundNotification, 
        object: nil)  
}

@objc func appWillEnterForeground() {
    updatePinImages()
}
```
</details>


## 애플 및 유져의 피드백 반영

### 앱스토어 심사 피드백

<details>
<summary>1. 앱 등록 심사 거절 사례</summary>

- 앱은 사용자가  **`계정 기반이 아닌 기능에 엑세스`** 하기 위해 등록하거나 로그인해야 합니다.
- 앱은 앱의 핵심 기능과 직접 관련이 있거나 법에 의해 요구되는 경우를 제외하고는 사용자가 기능하기 위해 개인 정보를 입력할 것을 요구하지 않을 수 있습니다.
- **💡’게스트로 로그인’ 모드 추가**
    - ‘게스트로 로그인’ 버튼 클릭 시 게스트 모드로 어플 진입
    - 스크랩, 북마크, 채팅방 메시지 보내기 등의 앱내 필수 기능 이용 불가
    - → alert 띄워 알려주고 로그인 하러가도록 유도

- 앱 심사 제출물은 모든 필요한 메타데이터와 완전히 작동하는 URL이 포함된 최종 버전이어야 하며, 자리 표시자 텍스트나 빈 웹사이트 등의 임시 콘텐츠는 제출 전에 제거되어야 합니다.
- 제출 전에 기기에서  **`앱을 테스트하여 버그와 안정성을 확인`** 하고, 데모 계정 정보와 백엔드 서비스가 켜져 있는지 확인해야 합니다. 법적 또는 보안상의 이유로 데모 계정을 제공할 수 없는 경우, 사전 승인된 데모 모드를 포함할 수 있습니다.
- **💡’Firebase 보안 규칙’ 재 점검**
    - Firebase 보안 규칙에서 Auth관련 부분을 수정

</details>

<details>
<summary>2. 앱 업데이트 심사 거절 사례 (1.0.3)</summary>

- **`사용자가 약관(EULA)에 동의`** 할 것을 요구하며, 이러한 약관은 반대할 수 있는 내용이나 욕설 사용자에 대한 허용이 없음을 분명히 해야 합니다.
- 이의가 있는 내용을 **`필터링`** 하는 방법
- 사용자가 악용하는 **`사용자를 차단하는 메커니즘`**
- 개발자는 24시간 이내에 해당 내용을 삭제하고 해당 내용을 제공한 사용자를 퇴장시킴으로써 이의가 있는 내용 보고에 대해 조치를 취해야 합니다.
- 커뮤니티의 **`모든 권한을 가지고 있는 계정을 제공`** 해주세요.
- **💡 개인정보 이용약관 개설 및 동의 페이지 생성**
    - 회원 가입시 유져에게 이용악관에 대한 동의를 반드시 요구하는 페이지를 생성
    - 동의하지 않는 경우 로그인 불가
- **💡 커뮤니티, 게시글 신고 기능**
    - 리뷰글, 채팅방 메세지 및 이미지에 대해 신고 기능 구현
    - 신고 3회 누적 또는 성적/폭력성 사유는 즉시 차단
    - 신고 유저 및 게시글 관리하는 관리자 화면 구현
- **💡 커뮤니티, 게시글 및 유저 차단 기능**
    - 리뷰글, 채팅방 메세지에 대한 기존의 신고 기능 뿐만 아니라 사용자가 다른 사용자 글을 즉시 보지 않을 수 있도록 차단 기능 구현
    - 이후 마이페이지에서 커뮤니티에서 차단한 유저를 해제 가능
- **💡 관리자 계정 생성**
    - 커뮤니티 지역채팅 모든 권한을 가지고 있는 관리자 계정 생성

</details>

### 유저 테스트 피드백

<details>
<summary>1. 로그인 페이지</summary>

- 게스트로 로그인 한 후에 `앱을 둘러보다가 로그인 할 수 있는 방법`이 있으면 좋겠습니다.(마이페이지의 프로필을 눌렀을 때, 채팅을 시도했을 때 등등) 현재는 앱을 다시 실행하거나 로그아웃 버튼을 누르고 할 수 있네요!
- **💡 게스트 모드 로그인 개선**
    - 로그인이 필요하다는 Alert가 존재하였으나, 기존에는 확인을 눌렀을때 아무런 변화가 없었음, 이후 피드백을 기반으로 개선을 한 버전에서는 확인을 했을때 로그인 페이지로 자동이동, 취소를 하면 더 기능을 둘러보게끔 변경
    - 마이페이지에서 게스트는 로그아웃이 아니라, 로그인 하러가기로 텍스트를 바꾸면서 세부적인 디테일 수정

</details>

<details>
<summary>2. 추천 페이지</summary>

- `첫 로드가 느린데` 혹시 씬델리게이트에서 먼저 사진을 불러올 수는 없었는지... 런치스크린이 끝나고 로드하는 시간이 또 있어서 앱이 느려보임
- **💡 추천 페이지 개선**
    - 기존에는 모든 내용의 데이터를 가져왔기에 로드하는시간이 오래 걸렸음.
        - 해당부분에 대해 이미지 및 필요한 데이터만 가져오는 최적화 작업 진행
        - 상세 페이지에 들어가면서 데이터를 가져오는 과정이 추가로 생겼으나 Indicator 표시로 유저로 하여금 페이지 로딩 중이라는것을 표시.
    - 세부페이지의 이미지 역시 최적화 작업 진행
    - 해당 부분은 SceneDelegate에서 미리 로드를 한다고 하더라도 기존 코드가 데이터를 전체를 불러오게 되어있기에 크게 의미는 없을 것으로 판단.
        - 물론 데이터를 메모리에 저장후 싱글턴 패턴을 사용한다면 첫 로드 이후에는 데이터를 불러오는데 있어 크게 향상효과를 기대할 수 있음

</details>

<details>
<summary>3. 지도 페이지</summary>

- 지도 화면에 들어섰을때 내 위치는 바로 표시되나 위치를 검색 해야 떡볶이 가게가 표시되고 있어 현재 `내 위치 주변 가게를 바로 보여주는 기능`이 있으면 사용자가 지도탭을 사용했을때 단순히 지도화면이 아닌 검색 후 떡볶이 가게를 알 수 있는 화면이구나 라고 알 수 있을 것 같습니다. (외 1건)
- **💡 지도 페이지 개선**
    - 공공 데이터 기반으로 내 위치 주변 분식집 추가

</details>

<details>
<summary>4. 커뮤니티 페이지</summary>

- 커뮤니티 탭에서 내 지역에서만 채팅이 가능하다고 한다면, **`내 지역을 목록에서 제일 상단에 위치`** 했으면 좋겠습니다! (외 1건)
- **💡커뮤니티 채팅 개선**
    - 기존 텍스트 전송만 가능했지만 `사진` 촬영과 라이브러리 및 `지도` 기능 추가가 가능
    - 기존 Date 및 Timestamp 없음 → 유저피드백 참고하여 Date 섹션 및 Timestamp 기능 추가
    - 위치별 Channel(서울특별시, 부산광역시 등) 진입을 사용자 위치 기반으로 파악하여 실사용자 위주의 커뮤니티 환경 구축
    - 현재 사용자 위치의 지역을 제일 상단에 노출, 그리고 현재 지역이라고 추가로 표시

</details>

<details>
<summary>5. 마이페이지</summary>

- 마이페이지의 나의 찜 목록에서 **`북마크와 스크랩한 것들의 내용을 다시 볼 수가 없습니다!`** 스크랩에서는 주소라도 뜨지만, 북마크는 추천 제목(?)만 확인 가능한 것이 아쉽습니다 ㅠㅠ 다시 세부 내용을 보여줬으면 좋겠어요! (외 1건)
- 마이페이지의 공지사항 뒤로가기 버튼과 다른 나의 찜 목록이나 내가 쓴 리뷰 항목의 **`뒤로가기 버튼을 통일`**했으면 좋겠습니다! 지금은 서로 모양이 다르네요! 그리고 나의 찜 목록이나 내가 쓴 리뷰 항목에 다녀왔다가 다시 공지사항에 들어가면 뒤로가기 버튼이 없습니다!
- **💡나의 찜목록 관련 개선**
    - 스크랩 또는 북마크 cell 클릭 시 각각 상세 페이지로 이동 → 북마크와 스크랩 기능 차별화
    - navigationBar 이용해 앱 전체의 back button UI 통일 및 뒤로가기 제스쳐 지원

</details>

