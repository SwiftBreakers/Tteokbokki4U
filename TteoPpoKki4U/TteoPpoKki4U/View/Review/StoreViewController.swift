//
//  StoreViewController.swift
//  TteoPpoKki4U
//
//  Created by 박미림 on 6/5/24.
//

import UIKit
import SnapKit
import Combine
import FirebaseAuth
import Kingfisher

class StoreViewController: UIViewController {
    
    // UI Components
    private lazy var customHeaderView = UIView()
    private lazy var scrollView = UIScrollView()
    private lazy var stackView = UIStackView()
    private lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.fontBold(size: 24)
        label.textAlignment = .center
        label.textColor = ThemeColor.mainBlack
        label.sizeToFit()
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.fontRegular(size: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    private lazy var callNumberLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.fontRegular(size: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    private lazy var seperateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "D9D9D9")
        return view
    }()
    private lazy var reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.fontMedium()
        label.textColor = ThemeColor.mainBlack
        label.sizeToFit()
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewTableViewCell")
        tableView.rowHeight = 85
        tableView.backgroundColor = .white
        return tableView
    }()
    private lazy var goReviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("리뷰 작성하기", for: .normal)
        btn.titleLabel?.font = ThemeFont.fontBold(size: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = ThemeColor.mainOrange
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var addressText: String?
    var shopTitleText: String?
    var callNumberText: String?
    // Dummy data
    private let storeName = "울랄라 떡볶이"
    private let storeImages = ["tpkImage1", "tpkImage1WithBg"]
    private let storeLocation = "123길 123"
    
    let viewModel = ReviewViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRequest()
        bind()
        setTabAndNavi()
    }
    
    private func fetchRequest() {
        viewModel.getStoreReview(storeName: shopTitleText!, storeAddress: addressText!)
    }
    
    private func bind() {
        viewModel.$userReview
            .receive(on: DispatchQueue.main)
            .sink { array in
                self.reviewCountLabel.text = "리뷰 \(array.count)개"
                if array.count == 0 {
                    self.setEmptyMsg("아직 작성한 리뷰가 없어요!\n  첫 리뷰를 작성해 주세요.")
                    self.tableView.reloadData()
                } else {
                    self.restore()
                    self.tableView.reloadData()
                }
                
            }.store(in: &cancellables)
        
        viewModel.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }.store(in: &cancellables)
        
        viewModel.reviewPublisher.sink { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                print(error)
            }
        } receiveValue: { _ in
        }.store(in: &cancellables)
    }
    
    // MARK: - setUI
    private func setTabAndNavi() {
        tabBarController?.tabBar.isHidden = true
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = ThemeColor.mainOrange
        navigationItem.title = "가게 정보"
        appearance.titleTextAttributes = [.foregroundColor: ThemeColor.mainBlack]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViews() {
        view.backgroundColor = .white

        [scrollView, storeNameLabel, locationLabel, callNumberLabel, seperateView, reviewCountLabel].forEach {
            customHeaderView.addSubview($0)
        }
        customHeaderView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = customHeaderView
        view.addSubview(tableView)
        
        // Setup Scroll View and Stack View
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        
        // Add images to stack view
        for imageName in storeImages {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            // 그라데이션 설정
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = imageView.bounds
            
            let colors: [CGColor] = [
                .init(red: 0, green: 0, blue: 0, alpha: 0.3),
                .init(red: 0, green: 0, blue: 0, alpha: 0.0)
            ]
            gradientLayer.colors = colors
            
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.locations = [0.0, 0.1]
            scrollView.layer.addSublayer(gradientLayer)
            
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width).multipliedBy(0.8)
                make.height.equalTo(imageView.snp.width).multipliedBy(0.75) // 4:3 aspect ratio
            }
        }
        
        storeNameLabel.text = shopTitleText
        locationLabel.text = addressText
        callNumberLabel.attributedText = makeIconBeforeText(icon: "phone.fill", label: callNumberText ?? "가게 번호 없음")
        
        // Setup Review Button
        view.addSubview(goReviewButton)
        goReviewButton.addTarget(self, action: #selector(goReviewButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupConstraints() {
        // Table View Constraints
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(goReviewButton.snp.top).inset(-10)
        }
        
        customHeaderView.snp.makeConstraints { make in
            make.width.equalTo(tableView.snp.width)
            make.height.equalTo(450)
        }
        
        // Scroll View Constraints
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(0.8 * 0.75) // 4:3 aspect ratio of the image views
        }
        
        // Stack View Constraints
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Title Label Constraints
        storeNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(20)
        }
        
        // Location Label Constraints
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        callNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            //make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        seperateView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(6)
        }
        
        reviewCountLabel.snp.makeConstraints { make in
            make.top.equalTo(seperateView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
        
        // Review Button Constraints
        goReviewButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc private func goReviewButtonTapped() {
        if let _ = Auth.auth().currentUser?.uid {
            let writeVC = WriteViewController()
            writeVC.addressText = addressText
            writeVC.storeTitleText = shopTitleText
            navigationController?.pushViewController(writeVC, animated: true)
        } else {
            showMessageWithCancel(title: "로그인이 필요한 기능입니다.", message: "확인을 클릭하시면 로그인 페이지로 이동합니다.") {
                let scene = UIApplication.shared.connectedScenes.first
                if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.switchToGreetingViewController()
                }
            }
        }
    }
    
    private func setEmptyMsg(_ msg: String) {
        let container = UIView()
        let msgLabel: UILabel = {
            let label = UILabel()
            label.text = msg
            label.textColor = .gray
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = ThemeFont.fontRegular()
            label.sizeToFit()
            label.setLineSpacing(lineSpacing: 5)
            return label
        }()
        container.addSubview(msgLabel)
        tableView.backgroundView = container
        
        msgLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func restore() {
        tableView.backgroundView = nil
    }
    
    // uilabel 텍스트 앞에 아이콘 넣기
    private func makeIconBeforeText(icon: String, label: String) -> NSMutableAttributedString {
        let iconImage = UIImage(systemName: icon)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        let attachment = NSTextAttachment()
        attachment.image = iconImage
        attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        
        // 이미지와 텍스트 결합
        let iconString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: label)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(iconString)
        mutableAttributedString.append(textString)
        
        return mutableAttributedString
    }
    
    @objc func reviewSubmitted() {
        MapViewModel().loadStore(with: self.shopTitleText!)
    }
    
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            let item = viewModel.userReview[indexPath.row]
            
            // Review 데이터를 먼저 설정
            cell.reviewTitleLabel.text = item.title
            cell.starRatingLabel.text = "⭐️ \(item.rating)"
            cell.createdAtLabel.text = viewModel.timestampToString(value: item.createdAt)
            
            if let thumbnail = item.imageURL.first {
                cell.thumbnailImage.kf.setImage(with: URL(string: thumbnail))
            } else {
                cell.thumbnailImage.image = nil
            }
            
            // 비동기로 유저 정보를 가져와서 닉네임 설정
            viewModel.getUserInfo(uid: item.uid) { userModel in
                if let userModel = userModel {
                    DispatchQueue.main.async {
                        if let updateCell = tableView.cellForRow(at: indexPath) as? ReviewTableViewCell {
                            updateCell.nicknameLabel.text = userModel.nickName
                        }
                    }
                } 
            }
            
            return cell
        }
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.userReview[indexPath.row]
        let detailedReviewVC = DetailedReviewViewController()
        detailedReviewVC.userData = item
        detailedReviewVC.userInfo = viewModel.userInfo[indexPath.row]
        navigationController?.pushViewController(detailedReviewVC, animated: true)
    }
    
}
