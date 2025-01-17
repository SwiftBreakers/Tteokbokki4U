//
//  RecommendCardView.swift
//  TteoPpoKki4U
//
//  Created by 최진문 on 2024/05/30.
//

import UIKit
import VerticalCardSwiper
import SnapKit
import FirebaseAuth
import Combine
import Kingfisher

public class MyCardCell: CardCell {
    
    public let titleLabel = UILabel()
    weak var customAlertViewController: UIViewController?
    public var card: Card?
    public let descriptionLabel = UILabel()
    public let imageURL = UILabel()
    public let imageView = UIImageView()
    public let bookmarkButton = UIButton()
    public let viewModel = CardViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    public var isBookmarked = false {
        didSet {
            if isBookmarked {
                bookmarkButton.setImage(.bookmark1, for: .normal)
            } else {
                bookmarkButton.setImage(.bookmark0, for: .normal)
            }
        }
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setCardUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with card: CardShell) {
        titleLabel.text = card.title
        descriptionLabel.text = card.description
        imageURL.text = card.imageURL
        if let url = URL(string: card.imageURL) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        else {
            imageView.image = UIImage(named: "placeholder")
        }
        bind()
        Task {
            await viewModel.fetchBookmarkStatus(title: card.title)
        }
    }
    
    private func bind() {
        viewModel.$isBookmarked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isBookmarked in
                self?.isBookmarked = isBookmarked
            }
            .store(in: &cancellables)
    }
    
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bookmarkButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(20)
            make.trailing.equalTo(imageView.snp.trailing).offset(-10)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalTo(descriptionLabel.snp.bottom).inset(35)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    public func setCardUI() {
        // 그라데이션 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let colors: [CGColor] = [
            .init(red: 0, green: 0, blue: 0, alpha: 0.0),
            .init(red: 0, green: 0, blue: 0, alpha: 0.9)
        ]
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.6, 1.0]
        imageView.layer.addSublayer(gradientLayer)
        
        
        bookmarkButton.setImage(.bookmark0, for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
        titleLabel.font = ThemeFont.fontBold(size: 40)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        
        descriptionLabel.font = ThemeFont.fontRegular(size: 20)
        descriptionLabel.textColor = .white
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 12
    }
    
    @objc func bookmarkTapped() {
        guard let viewController = customAlertViewController else { return }
        if let _ = Auth.auth().currentUser?.uid {
            if isBookmarked {
                bookmarkButton.setImage(.bookmark0, for: .normal)
                viewModel.deleteBookmarkItem(title: titleLabel.text!)
                let bookmark0Image = UIImageView()
                bookmark0Image.image = .bookmark0
                viewController.showNegativeCustomAlert(image: bookmark0Image.image!, message: "북마크에서 삭제 되었어요.")
                
            } else {
                bookmarkButton.setImage(.bookmark1, for: .normal)
                viewModel.createBookmarkItem(title: titleLabel.text!, imageURL: imageURL.text!)
                let bookmark1Image = UIImageView()
                bookmark1Image.image = .bookmark1
                viewController.showPositiveCustomAlert(image: bookmark1Image.image!, message: "북마크에 추가 되었어요.")
            }
        } else {
            let userXImage = UIImageView()
            userXImage.image = .userX
            viewController.showPositiveCustomAlert(image: userXImage.image!, message: "로그인이 필요한 기능입니다.")
        }
    }
    
}
