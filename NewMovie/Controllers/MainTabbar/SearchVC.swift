//
//  SearchVC.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class SearchVC: UIViewController {
    var isOn = false
    var arrString = ["Gia đình","Tâm lý","Hành động","Hài","Phim Việt", "Kiếm hiệp","Lãng mạn","Tài liệu","Cổ Trang","Kinh dị"]
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    private let viewIn: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let label1: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Có thể bạn quan tâm"
        lable.font = .systemFont(ofSize: 18, weight: .heavy)
        lable.textColor = .white
        lable.numberOfLines = 0
        return lable
    }()
    private let button1: UIButton = {
        let button = UIButton()
        button.setTitle(" Xem thêm", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    private let collectionView1: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.register(CollectionViewCell2.self, forCellWithReuseIdentifier: CollectionViewCell2.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = false
        return collection
    }()
    private let collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = false
        return collection
    }()
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .default
        return controller
    }()
    var titles = [Title]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: UIBarAppearance())
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.backgroundColor = .black
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        title = "Tìm kiếm"
        view.addSubview(scrollView)
        scrollView.addSubview(viewIn)
        viewIn.addSubview(collectionView1)
        viewIn.addSubview(button1)
        viewIn.addSubview(label1)
        viewIn.addSubview(collectionView2)
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView2.dataSource = self
        collectionView2.delegate = self
        setupConstans()
        button1.addTarget(self, action: #selector(tapOnBt), for: .touchUpInside)
        Task {
            do {
                let url = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.APIkey)"
                let title: TrendingTitleResponse = try await APICaller.shared.fetchAPI(url: URL(string: url)!)
                let results = title.results
                self.titles = results
                print("\(titles.count)1")
                collectionView2.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    @objc func tapOnBt() {
        isOn = !isOn
        print(isOn)
        if isOn == true {
            button1.setTitle(" Rút gọn", for: .normal)
            button1.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            collectionView1.heightConstraint?.constant = 440
            viewIn.heightConstraint?.constant = 1380
            viewIn.layoutIfNeeded()
            collectionView1.layoutIfNeeded()
        } else {
            button1.setTitle(" Xem thêm", for: .normal)
            button1.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            collectionView1.heightConstraint?.constant = 270
            viewIn.heightConstraint?.constant = 1210
            viewIn.layoutIfNeeded()
            collectionView1.layoutIfNeeded()
        }
        
        
//        collectionView1.heightAnchor.constraint(equalToConstant: 440).isActive = true
//        viewIn.heightAnchor.constraint(equalToConstant: 1380).isActive = true
////            viewIn.heightAnchor.constraint(equalToConstant: 1380).isActive = true
//        viewIn.heightAnchor.constraint(equalToConstant: 1210).isActive = false
//        collectionView1.heightAnchor.constraint(equalToConstant: 270).isActive = false
    }
    func setupConstans() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        viewIn.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        viewIn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        viewIn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        viewIn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        viewIn.heightAnchor.constraint(equalToConstant: 1210).isActive = true
        
        viewIn.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        collectionView1.topAnchor.constraint(equalTo: viewIn.topAnchor).isActive = true
        collectionView1.leadingAnchor.constraint(equalTo: viewIn.leadingAnchor).isActive = true
        collectionView1.trailingAnchor.constraint(equalTo: viewIn.trailingAnchor).isActive = true
        collectionView1.heightAnchor.constraint(equalToConstant: 270).isActive = true
        

        button1.topAnchor.constraint(equalTo: collectionView1.bottomAnchor).isActive = true
        button1.leadingAnchor.constraint(equalTo: viewIn.leadingAnchor).isActive = true
        button1.trailingAnchor.constraint(equalTo: viewIn.trailingAnchor).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 20).isActive = true

        label1.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20).isActive = true
        label1.leadingAnchor.constraint(equalTo: viewIn.leadingAnchor, constant: 20).isActive = true
        label1.trailingAnchor.constraint(equalTo: viewIn.trailingAnchor).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 20).isActive = true

        collectionView2.topAnchor.constraint(equalTo: label1.bottomAnchor).isActive = true
        collectionView2.trailingAnchor.constraint(equalTo: viewIn.trailingAnchor).isActive = true
        collectionView2.leadingAnchor.constraint(equalTo: viewIn.leadingAnchor).isActive = true
        collectionView2.bottomAnchor.constraint(equalTo: viewIn.bottomAnchor, constant: -50).isActive = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
////        scrollView.frame = view.bounds
////        viewIn.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 1210)
//        collectionView1.frame = CGRect(x: 0, y: 0, width: viewIn.frame.width, height: 270)
//        button1.frame = CGRect(x: Int(viewIn.frame.width)/2-60, y: Int(collectionView1.frame.height), width: 120, height: 20)
//        label1.frame = CGRect(x: 20, y: button1.frame.height + collectionView1.frame.height + 20, width: scrollView.frame.width, height: 20)
//        collectionView2.frame = CGRect(x: 0, y: button1.frame.height + collectionView1.frame.height + 20 + label1.frame.height, width: scrollView.frame.width, height: 1000)
    }

   

}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return 10
        } else {
            return titles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell2.identifier, for: indexPath) as! CollectionViewCell2
            cell.configure(title: arrString[indexPath.row])
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            cell.configure(with: titles[indexPath.row].poster_path!)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
         return  CGSize(width: view.frame.width/2-30, height: 70)
        }
        return CGSize(width: view.frame.width/2-30, height: 80)
    }
    
}
extension SearchVC: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else {
                  return
              }
        resultsController.delegate = self
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.APIkey)&query=\(query)") else {
            return
        }
        Task {
            do {
                let results: TrendingTitleResponse = try await APICaller.shared.fetchAPI(url: url)
                resultsController.titles = results.results
                resultsController.searchResultsCollectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
//        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var widthConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .width && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

}

