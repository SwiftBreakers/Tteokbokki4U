//
//  PrivacyPolicyViewController.swift
//  TteoPpoKki4U
//
//  Created by 김건응 on 6/21/24.
//

import Foundation
import UIKit
import SnapKit

class PrivacyPolicyViewController: UIViewController, UIScrollViewDelegate {
    
//    var backButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(systemName: "chevron.backward.2")
//        button.setImage(image, for: .normal)
//        button.tintColor = .gray
//        button.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
   
    var textView: UITextView = {
        
        let text = UITextView()
        text.textColor = ThemeColor.mainBlack
        text.backgroundColor = .white
        return text
        
    }()
    
    var label: UILabel = {
       let text = UILabel()
        text.textColor = ThemeColor.mainBlack
        return text
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // 배경색 설정
       
//        setupBackButton()
        setupTopLabel()
        setupTextView()
    
        navigationController?.navigationBar.tintColor = ThemeColor.mainOrange

        
    }
    
  
    func setupTopLabel() {
        label.text = "개인정보 처리방침"
        view.addSubview(label)
        
        label.font = ThemeFont.fontBold(size: 20)
        label.textColor = ThemeColor.mainBlack
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.centerX.equalToSuperview()
        }
    }
    
    
    func setupTextView() {
        textView.text = privacyPolicyText().privacytext
        view.addSubview(textView)
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8 // 원하는 행간 값 설정

            let attributedString = NSMutableAttributedString(string: privacyPolicyText().privacytext, attributes: [
                .font: ThemeFont.fontRegular(size: 14), // 폰트 설정
                .paragraphStyle: paragraphStyle // 행간 설정
            ])
            
            textView.attributedText = attributedString
        textView.textColor = ThemeColor.mainBlack
       
        textView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        textView.isEditable = false
    }

    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        
    }
//    func setupBackButton() {
//        view.addSubview(backButton)
//        
//        
//        backButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-340)
//            make.height.equalTo(30)
//        }
//    }
    
}
