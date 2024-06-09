//
//  WriteViewController.swift
//  TteoPpoKki4U
//
//  Created by 박미림 on 6/3/24.
//

import UIKit
import SnapKit
import YPImagePicker
import Firebase
import FirebaseAuth
import FirebaseStorage
import Combine
import Kingfisher
import ProgressHUD

class WriteViewController: UIViewController {
    
    
    let starStackView = UIStackView()
    
    var starButtons: [UIButton] = []
    var selectedRating = 0
    
    let titleTextField = UITextField()
    let contentTextView = UITextView()
    let addImageButton = UIButton()
    let cancelButton = UIButton()
    let submitButton = UIButton()
    
    var selectedImages: [UIImage] = []
    let imageScrollView = UIScrollView()
    let imageStackView = UIStackView()
    
    var addressText: String?
    var storeTitleText: String?
    
    var isEditMode: Bool = false
    var isNavagtion: Bool = false
    var review: ReviewModel?
    
    private var cancellables = Set<AnyCancellable>()
    let viewModel = ReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bind()
        setDataForEdit()
    }
    
    private func setDataForEdit() {
        if review != nil {
            titleTextField.text = review?.title
            contentTextView.text = review?.content
            selectedRating = Int(review!.rating)
            addressText = review?.storeAddress
            storeTitleText = review?.storeName
            updateStarButtons()
            getImages()
        }
    }
    
    private func getImages() {
        review?.imageURL.forEach { url in
            guard let imageURL = URL(string: url) else { return }
            KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.addImageToStackView(image: image.image)
                        self.selectedImages.append(image.image)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func bind() {
        viewModel.reviewPublisher.sink { [weak self] completion in
            switch completion {
            case .finished:
                return
            case .failure(let error) :
                let alert = UIAlertController(title: "에러 발생", message: "\(error.localizedDescription)이 발생했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
        } receiveValue: { _ in
            
        }.store(in: &cancellables)
        
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 별점 라벨
        let starLabel = UILabel()
        if isEditMode {
            starLabel.text = "별점 리뷰 수정"
            submitButton.setTitle("리뷰 수정", for: .normal)
        } else {
            starLabel.text = "별점 리뷰 작성"
            submitButton.setTitle("리뷰 등록", for: .normal)
        }
        starLabel.font = UIFont.boldSystemFont(ofSize: 22)
        view.addSubview(starLabel)
        starLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
        }
        
        // 별점 버튼들 설정
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 10
        view.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(starLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(110)
            make.right.equalToSuperview().offset(-110)
        }
        
        for i in 1...5 {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.setImage(UIImage(systemName: "star.fill"), for: .selected)
            button.tintColor = .orange
            button.tag = i
            button.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            starStackView.addArrangedSubview(button)
            starButtons.append(button)
        }
        
        // 제목 텍스트 필드 설정
        titleTextField.placeholder = "제목"
        titleTextField.borderStyle = .roundedRect
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(starStackView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 내용 텍스트 뷰 설정
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.cornerRadius = 5
        contentTextView.font = UIFont.systemFont(ofSize: 17)
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(150)
        }
        
        // 이미지 추가 버튼
        addImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addImageButton.backgroundColor = .systemGray5
        addImageButton.layer.cornerRadius = 5
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        // MARK: - 여기 스크롤 되는지 모르겠음....
        // 이미지 스크롤뷰 설정
        imageScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(addImageButton.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(90)
        }
        
        // 이미지 스택뷰 설정
        imageStackView.axis = .horizontal
        imageStackView.spacing = 10
        imageScrollView.addSubview(imageStackView)
        imageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        // 취소 버튼 설정
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .systemGray
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        // 등록 버튼 설정
        submitButton.setTitle("리뷰 등록", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .orange
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalTo(cancelButton.snp.trailing).offset(16)
            make.height.equalTo(50)
        }
    }
    
    private func reviewTapped() {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let title = titleTextField.text,
            let content = contentTextView.text
        else {
            return
        }
        
        uploadImages(images: selectedImages)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    let alert = UIAlertController(title: "에러 발생", message: "\(error.localizedDescription)이 발생했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }, receiveValue: { [weak self] imageURLs in
                guard let self = self else { return }
                
                let dictionary: [String: Any] = [
                    "uid": uid,
                    "title": title,
                    "storeAddress": self.addressText!,
                    "storeName": self.storeTitleText!,
                    "content": content,
                    "rating": self.selectedRating,
                    "imageURL": imageURLs,
                    "isActive": false,
                    "createdAt": self.isEditMode ? self.review!.createdAt : Timestamp(date: Date()),
                    "updatedAt": Timestamp(date: Date())
                ]
                
                if isEditMode {
                    viewModel.editUserReview(uid: uid, storeAddress: self.addressText!, title: review!.title, userDict: dictionary)
                } else {
                    viewModel.createReview(userDict: dictionary)
                }
            })
            .store(in: &cancellables)
        
        ProgressHUD.animate()
        let alertTitle = isEditMode ? "리뷰 수정" : "리뷰 저장"
        let alertMessage = isEditMode ? "리뷰가 수정 되었습니다." : "리뷰가 등록 되었습니다."
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [unowned self] in
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [unowned self] _ in
                if isNavagtion {
                    navigationController?.popViewController(animated: true)
                } else {
                    dismiss(animated: true, completion: nil)
                }
            }))
            ProgressHUD.remove()
            present(alert, animated: true)
        }
    }
    
    private func updateStarButtons() {
        for (index, button) in starButtons.enumerated() {
            button.isSelected = index < selectedRating
        }
    }
    
    @objc func starButtonTapped(_ sender: UIButton) {
        selectedRating = sender.tag
        updateStarButtons()
    }
    
    @objc func cancelButtonTapped() {
        if isNavagtion {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func submitButtonTapped() {
        reviewTapped()
    }
    
    @objc func addImageButtonTapped() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 5
        config.startOnScreen = .library
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    self.selectedImages.append(photo.image)
                    self.addImageToStackView(image: photo.image)
                case .video(_):
                    break
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func addImageToStackView(image: UIImage) {
        let containerView = UIView()
        containerView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
        }
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let removeButton = UIButton(type: .custom)
        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = .systemGray6
        removeButton.addTarget(self, action: #selector(removeImageButtonTapped(_:)), for: .touchUpInside)
        containerView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(5)
            make.width.height.equalTo(20)
        }
        
        imageStackView.addArrangedSubview(containerView)
    }
    
    @objc func removeImageButtonTapped(_ sender: UIButton) {
        guard let containerView = sender.superview else { return }
        
        if let index = imageStackView.arrangedSubviews.firstIndex(of: containerView) {
            selectedImages.remove(at: index)
        }
        
        containerView.removeFromSuperview()
    }
    
    func uploadImage(image: UIImage) -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            let storageRef = Storage.storage().reference()
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let downloadURL = url {
                        promise(.success(downloadURL.absoluteString))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func uploadImages(images: [UIImage]) -> AnyPublisher<[String], Error> {
        let publishers = images.map { uploadImage(image: $0) }
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
}