//
//  HomeTableViewCell.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: HomeTableViewCell, viewModel: TitlePreviewViewModel)
}
class HomeTableViewCell: UITableViewCell {
    var models = [Title]()
  
    var delegate: CollectionViewTableViewCellDelegate?
    static let identifier = "cell1234"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collection.backgroundColor = .black
        return collection
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    func configure(with models: [Title]) {
        self.models = models
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    private func downloadTitleAt(indexPath: IndexPath) {
        
    
        DataPersistenceManager.shared.downloadTitleWith(model: models[indexPath.row]) { result in
            switch result {
            case .success(let success):
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                } else {
                    print(12345)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        

    }
}
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: models[indexPath.row].poster_path!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = models[indexPath.row]
        guard let titleName = title.original_title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let titleOverview = title.overview else {
            return
        }
        Task {
            do {
                guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(titleName)&key=\(Constants.YoutubeAPI_KEY)") else {
                    return
                }
                let result: YoutubeSearchResponse =  try await APICaller.shared.fetchAPI(url: url)
                let videoElement = result.items[0]
                self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview))
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}
