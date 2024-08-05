//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 심소영 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ShoppingListViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    let textField:UITextField = {
        let text = UITextField()
        text.placeholder = "  무엇을 구매하실 건가요?"
        text.layer.cornerRadius = 8
        return text
    }()
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 8
        button.contentMode = .center
        return button
    }()
    let disposeBag = DisposeBag()
    
    var checkList = [
        ShoppingList(like: true, check: false, textLabel: "그립톡 구매하기"),
        ShoppingList(like: true, check: false, textLabel: "사이다 구매"),
        ShoppingList(like: false, check: true, textLabel: "양말"),
        ShoppingList(like: true, check: true, textLabel: "양배추"),
        ShoppingList(like: false, check: false, textLabel: "아이패드 케이스"),
        ShoppingList(like: true, check: true, textLabel: "자전거"),
        ShoppingList(like: false, check: false, textLabel: "노트"),
        ShoppingList(like: false, check: true, textLabel: "세탁세제"),
        ShoppingList(like: true, check: true, textLabel: "면봉"),
    ]
    lazy var list = BehaviorSubject(value: checkList)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쇼핑"
        view.backgroundColor = .white
        textField.backgroundColor = .systemGray6
        configure()
        bind()
    }
    private func configure() {
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(addButton)
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(30)
            make.width.equalTo(45)
        }
    }
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    func bind(){
        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                
                cell.todoLabel.text = element.textLabel
                
                let check = element.check ? "checkmark.square.fill" : "checkmark.square"
                let checkImage = UIImage(systemName: check)
                cell.checkImageView.setImage(checkImage, for: .normal)
                
                let like = element.like ? "star.fill" : "star"
                let likeImage = UIImage(systemName: like)
                cell.likeImageView.setImage(likeImage, for: .normal)
                
                cell.checkImageView.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.checkList[row].check.toggle()
                        owner.list.onNext(owner.checkList)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.likeImageView.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.checkList[row].like.toggle()
                        owner.list.onNext(owner.checkList)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.checkList.remove(at: indexPath.row)
                self?.list.onNext(self?.checkList ?? [])
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(onNext: { value in
                guard let text = self.textField.text, text.count > 1 else {
                    self.textField.placeholder = "2글자 이상 입력해주세요"
                    return
                }
                let newItem = ShoppingList(like: false, check: false, textLabel: text)
                self.checkList.append(newItem)
                
                self.textField.text = ""
                self.list.onNext(self.checkList)
            })
            .disposed(by: disposeBag)
    }
}

