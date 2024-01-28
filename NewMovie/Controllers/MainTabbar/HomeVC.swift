//
//  HomeVC.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit
import ImageSlideshow
import Alamofire
import ImageSlideshowAlamofire
import AlamofireImage
enum Sections: Int {
   case trendingMovie = 0
   case trendingTv = 1
    
    
}
class HomeVC: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        table.backgroundColor = .black
        return table
    }()
    var Section = ["Chương Trình Hôm Nay", "Phim Đang Chiếu", "Bảng Xếp Hạng Tuần", "Phim Phổ Biến", "Phim TV Phổ Biến","Phim Sắp Chiếu", "Phim Thịnh Hành", "Chương Trình TV Thịnh Hành"]
    var models = [[Title]]()
    var headerView: HearderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: UIBarAppearance())
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .red
        view.addSubview(tableView)
        title = "Trang chủ"
        configureNavbar()
        headerView = HearderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        configureHeaderView()
     Task   {
             do {
                 let urls = [URL(string:  "\(Constants.baseURL)/3/tv/airing_today?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/now_playing?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/tv/popular?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.APIkey)")!, URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.APIkey)")!]
                 let results: [TrendingTitleResponse] = try await APICaller.shared.fetchAPIs(urls: urls)
                 for result1 in results {
                     let model = result1.results
                     models.append(model)
                     
                 }
                 tableView.reloadData()
                 print(models.count)
             } catch {
                 print(error.localizedDescription)
             }
         }
    }
    private func configureHeaderView()  {
        Task {
            do {
                let url = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.APIkey)"
                let title: TrendingTitleResponse = try await APICaller.shared.fetchAPI(url: URL(string: url)!)
                var arr = [InputSource]()
                let results = title.results
                for i in 0..<results.count {
                    let result = results[i].poster_path
                    let arr1 = AlamofireSource(url: URL(string: "https://image.tmdb.org/t/p/w500/\(result!)")!)
                    arr.append(arr1)
                }
                self.headerView?.configure(with: arr)
                self.headerView?.congigure1(with: title.results)
                self.headerView?.delegate = self
                self.headerView?.delegate1 = self
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
    }
    private func configureNavbar() {
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    func getData() {
       Task {
            do {
                let urls = [URL(string:  "\(Constants.baseURL)/3/tv/airing_today?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/now_playing?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/tv/popular?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.APIkey)")!, URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.APIkey)")!,URL(string:  "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.APIkey)")!]
                let results: [TrendingTitleResponse] = try await APICaller.shared.fetchAPIs(urls: urls)
                for result1 in results {
                    let model = result1.results
                    models.append(model)
                    
                }
                tableView.reloadData()
                print(models.count)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func setupAlert(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Quay lại",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        if indexPath.section == 2 || indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            cell.configure(with: models[indexPath.section])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier)  as! HomeTableViewCell
            cell.configure(with: models[indexPath.section])
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 || indexPath.section == 5 {
            return 140
        } else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        view.addSubview(header)
        let label1 = UILabel()
        let label2 = UILabel()
        let button1 = UIButton()
        header.addSubview(label1)
        header.addSubview(label2)
        header.addSubview(button1)
        label1.frame = CGRect(x: 5, y: 5, width: Int(header.frame.size.width) - 100, height: 10)
        label1.text = Section[section]
        label1.textColor = .white
        button1.frame = CGRect(x: header.frame.size.width-30, y: 5, width: 20, height: 15)
        button1.setImage(UIImage(systemName: "play"), for: .normal)
        button1.tintColor = .white
        label1.font = .boldSystemFont(ofSize: 18)
        button1.addTarget(self, action: #selector(tapOn), for: .touchUpInside)
        button1.tag = section
        return header
        
        
    }
    @objc func tapOn(sender: UIButton) {
         
            let tag = sender.tag
            let vc = SearchResultsVC()
            vc.titles = models[tag]
            vc.title =  Section[tag]
        vc.delegate = self
        present(vc, animated: true)
        
        
        
    }
}
extension HomeVC: CollectionViewTableViewCellDelegate, CollectionViewTableViewCellDelegate1, CollectionViewTableViewCellDelegate2, CollectionViewTableViewCellDelegate3, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionViewTableViewCellDidTapCell2(_ view: Bool) {
        if view {
            setupAlert(title: "Thông báo", massage: "Tải phim thành công")
        } else {
            setupAlert(title: "Cảnh báo", massage: "Phim đã tải từ trước")
        }
    }
    
    func collectionViewTableViewCellDidTapCell2(_ view: HearderView, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionViewTableViewCellDidTapCell1(_ cell: TableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionViewTableViewCellDidTapCell(_ cell: HomeTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
struct Constants {
    static let baseURL = "https://api.themoviedb.org"
    static let APIkey = "697d439ac993538da4e3e60b54e762cd"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

