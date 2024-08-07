//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 심소영 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingListViewModel {
    let disposeBag = DisposeBag()
    
    //테이블뷰에 보여질 데이터
    var checkList = BehaviorSubject(value: [
        ShoppingList(like: true, check: false, textLabel: "그립톡 구매하기"),
        ShoppingList(like: true, check: false, textLabel: "사이다 구매"),
        ShoppingList(like: false, check: true, textLabel: "양말"),
        ShoppingList(like: true, check: true, textLabel: "양배추"),
        ShoppingList(like: false, check: false, textLabel: "아이패드 케이스"),
        ShoppingList(like: true, check: true, textLabel: "자전거"),
        ShoppingList(like: false, check: false, textLabel: "노트"),
        ShoppingList(like: false, check: true, textLabel: "세탁세제"),
        ShoppingList(like: true, check: true, textLabel: "면봉"),
    ])
    var recentList = BehaviorSubject(value: [
            "노트", "손들기", "컵", "마우스패드", "설거지", "쓰레기버리기"
        ])
    
    struct Input{
        let recentText: PublishSubject<ShoppingList> // 컬렉션 뷰 셀 클릭시 들어오는 글자, 테이블 뷰에 업데이트
        let searchButtonTap: ControlEvent<Void> // searchBar.rx.searchButtonClicked
        let searchText: ControlProperty<String> // searchBar.rx.text.orEmpty
    }
    struct Output{
        let shoppingList: Observable<[ShoppingList]> //테이블뷰
        let recentList: Observable<[String]> //컬렉션뷰 리스트에 추가도 해줘야하기에
    }
    func transform(input: Input) -> Output {
        
        input.recentText
            .subscribe(with: self) { owner, value in
                print("recentText", value)
                var addList = try! owner.checkList.value()
                addList.append(value)
                owner.checkList.onNext(addList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("서치버튼 탭 인식")
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("검색한 글자 뷰모델 \(value)")
            }
            .disposed(by: disposeBag)
        
        
        return Output(shoppingList: checkList.asObservable(), recentList: recentList.asObservable())
    }
    func toggleCheck(at index: Int) {
        var currentList = try! checkList.value()
        currentList[index].check.toggle()
        checkList.onNext(currentList)
    }
    
    // 좋아요 상태 변경 메서드
    func toggleLike(at index: Int) {
        var currentList = try! checkList.value()
        currentList[index].like.toggle()
        checkList.onNext(currentList)
    }
}
