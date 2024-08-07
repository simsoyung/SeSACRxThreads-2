//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let defalutsNumber = Observable.just("010")
   
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    func bind(){
        defalutsNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: dispose)
        
        let number = phoneTextField
            .rx
            .text
            .map {$0?.count ?? 0 >= 10}
        number
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: dispose)
        
        number
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: dispose)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("버튼 눌림")
            }
            .disposed(by: dispose)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
