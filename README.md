# Rick And Morty
## 사용한 기술
* UIKit
* MVVM
* Combine
* Concurrency
* Kingfisher
* Snapkit
* SPM

## 주요 기능
* Pagaination
* 캐릭터, 지역, 에피소드 검색
* Expandable List
* Loading View

## 구현 내용
### 1. Pagination
<img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/96a32bba-f3b2-4837-82f2-701f2fc268bf">

UICollectionView의 prefetchItemsAt 메서드를 이용하여 현재 indexPath가 뷰 모델이 가지고 있는 배열의 아이템 개수에 가까워지면 서버로 부터 데이터를 받아와 배열에 추가할 수 있게 구현하였습니다.

```swift
func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
        if vm.characters.count-1 == indexPath.row {
            vm.fetchCharacters()
        }
    }
}
```

### 2. 검색 기능
<img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/f27f8fd2-9886-4572-9e96-c82a2aeff383">

UISearchTextField extension에 AnyPublisher<String, Never> 타입을 반환하는 textPublisher라는 속성을 추가하였습니다. textPublisher는 NotificationCenter의 publisher 메서드를 사용하여 텍스트 필드의 텍스트가 변경될때마다 값을 방출합니다.

```swift
extension UISearchTextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
```

textPublisher를 구독하여 값이 들어올때마다 뷰 모델이 가지고있는 데이터를 업데이트합니다. 검색을 할때도 Pagination이 가능하도록 구현하였습니다.

```swift
private func setSearchControllerListener() {
    searchController.searchBar.searchTextField.textPublisher
        .sink { [weak self] searchText in
        /* ... */
    }.store(in: &cancellables)
}
```

### 3. Diffable DataSource
<img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/bad8b47b-9202-4100-a5f0-da81cf8870ae">

데이터가 변경될때마다 indexPath에 접근할 필요가 없이 안전하게 뷰를 업데이트하고 자연스러운 애니메이션을 적용하기 위해 Diffable DataSource를 사용하였습니다. 

### 4. Loading View
<img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/f622aa49-5c37-4cb4-b712-247ed456065e">

사용자에게 서버로부터 데이터를 받아오는 중이라는 것을 표현하기 위해 UIActivityIndicatorView를 가지고 있는 LoadingView를 만들었습니다. LoadingView에는 Boolean값을 가지고 있는 isLoading 속성이 있으며 이 속성에 따라 LoadingView의 숨김 여부와 UIActivityIndicatorView의 애니메이션의 동작을 결정합니다.

뷰 컨트롤러가 초기화 될때는 LoadingView를 보여준 뒤 Task 블록 안에 네트워킹을 완료하는 시점에 LoadingView를 숨기도록 하였습니다.

### 5. 다양한 컬렉션 뷰 레이아웃

| <img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/be089163-29e8-419d-b83d-0d897f918aee"> | <img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/625eabfd-761c-4170-bb0a-f2b719407376"> | <img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/b8ff6bce-4621-475e-971a-1a41cec8e5cf"> |
| ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |

UICollectionViewCompositionalLayout을 사용하여 multiple section의 다양한 레이아웃을 구현하였습니다.

### 6. Expandable List
<img width="200" src="https://github.com/devjuhyun/RickAndMorty/assets/117050638/813a00b4-0cf0-4155-af71-e5f70b38f8c5">

UICollectionViewListCell과 NSDiffableDataSourceSectionSnapshot을 사용하여 캐릭터 상세페이지에서 캐릭터가 출연한 에피소드 리스트를 접거나 펼칠 수 있게 구현해보았습니다.

## 문제점 해결
### 1. 무한 로딩 이슈
지역에 거주자가 없을 경우 특정 지역의 상세 페이지가 무한 로딩이 되는 현상이 있었습니다. do 블록안의 네트워킹을 하는 코드에서 에러를 반환하기 때문에 다음 줄인 isLoading 변수에 false를 할당하는 코드가 실행되지 않고 catch 블록으로 넘어가기 때문이었습니다. 따라서 지역 거주자가 존재하지 않을경우 isLoading을 false로 설정하고 함수를 실행하지 않고 반환하는 코드를 함수의 앞부분에 넣어줌으로써 해결하였습니다.

```swift
private func fetchCharacters() {
    if location.residents.isEmpty { isLoading = false; return }
        
    Task {
        do {
            residents = try await requestManager.perform(APIRequest.getMultipleCharacters(ids: ids))
            isLoading = false
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

### 2. Auto Layout 이슈
캐릭터의 이미지와 이름을 표시해주는 UICollectionViewCell에서 이미지의 크기가 캐릭터의 이름을 가려버리는 현상이 있었습니다. 이미지를 비동기적으로 다운로드 받기 때문에 생기는 문제라고 생각하여 캐릭터의 이름을 표시해줄 UILabel의 ContentCompressionResistancePriority를 최대인 required로 설정하여 해결했습니다.
