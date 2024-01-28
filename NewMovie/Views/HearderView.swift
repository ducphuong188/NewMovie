//
//  HearderView.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit
import ImageSlideshow
import Alamofire
import ImageSlideshowAlamofire
import AlamofireImage
protocol CollectionViewTableViewCellDelegate2: AnyObject {
    func collectionViewTableViewCellDidTapCell2(_ view: HearderView, viewModel: TitlePreviewViewModel)
}
protocol CollectionViewTableViewCellDelegate3: AnyObject {
    func collectionViewTableViewCellDidTapCell2(_ view: Bool)
}
class HearderView: UIView, ImageSlideshowDelegate {
    let pageIndicator = UIPageControl()
    var count = 0
    var model = [Title]()
    var delegate: CollectionViewTableViewCellDelegate2?
    var delegate1: CollectionViewTableViewCellDelegate3?
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Xem ngay", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let headerView1: ImageSlideshow = {
        let header = ImageSlideshow()
        header.backgroundColor = .black
        return header
    }()

    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView1)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        backgroundColor = .black
        playButton.addTarget(self, action: #selector(tapPlay), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(tapDown), for: .touchUpInside)
    }
    
    @objc func tapDown() {
        DataPersistenceManager.shared.downloadTitleWith(model: model[count]) { result in
            switch result {
            case .success(let success):
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                } else {
                    
                }
                self.delegate1?.collectionViewTableViewCellDidTapCell2(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    @objc func tapPlay() {
        
        guard let titleName = model[count ].original_title!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let titleView = model[count ].overview else { return  }
        Task {
            do {
                guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(titleName)&key=\(Constants.YoutubeAPI_KEY)") else {
                    print(100)
                    return
                }
                print(url)
                let result: YoutubeSearchResponse =  try await APICaller.shared.fetchAPI(url: url)
                let videoElement = result.items[0]
                print(videoElement)
                self.delegate?.collectionViewTableViewCellDidTapCell2(self, viewModel: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleView))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func congigure1(with model: [Title]) {
        self.model = model
    }
    private func applyConstraints() {
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
//        pageIndicator.pageIndicatorTintColor = UIColor.black
        
        DispatchQueue.main.async {
            self.count = page
        }
        
        
    }
    
    
    public func configure(with model: [InputSource]) {
        print(model)
        headerView1.setImageInputs(model)
        headerView1.slideshowInterval = 5.0
        headerView1.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        headerView1.contentScaleMode = UIViewContentMode.scaleToFill
        headerView1.delegate = self
        headerView1.activityIndicator = DefaultActivityIndicator()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerView1.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

}
class userHeaderView: UIView {
    private let button1: UIButton = {
        let button = UIButton()
        
        button.setTitle("Tiếp tục với Galaxy Play", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        
        return button
    }()
    private let label1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hãy tham gia Galaxy Play để thưởng thức hàng ngàn nội dung đặc sắc"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button1)
        addSubview(label1)
        applyConstraints()
        backgroundColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    private func applyConstraints() {
        
        let playButtonConstraints = [
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label1.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label1.widthAnchor.constraint(equalToConstant: 353),
            label1.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let downloadButtonConstraints = [
            button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            button1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            button1.widthAnchor.constraint(equalToConstant: 353),
            button1.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
