//
//  DownloadsVC.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class DownloadsVC: UIViewController {
    
    
    private var titles: [TitleItem] = [TitleItem]()
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "Chưa có dữ liệu"
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let downloadedTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tải về"
        view.addSubview(downloadedTable)
        view.addSubview(label1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    
    private func fetchLocalStorageForDownload() {

        
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                print(self?.titles.count)
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            
            if self.titles.count == 0 {
                
                self.downloadedTable.isHidden = true
                self.label1.isHidden = false
            } else {
                self.downloadedTable.isHidden = false
                self.label1.isHidden = true
                
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
        label1.frame = CGRect(x: 40, y: 100, width: view.frame.width-80, height: view.frame.height-200)
    }
    

}
extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(titleName)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        Task {
            do {
                let result: YoutubeSearchResponse =  try await APICaller.shared.fetchAPI(url: url)
                let videoElement = result.items[0]
                let vc = PreviewVC()
                vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                navigationController?.pushViewController(vc, animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
 
    
    
}
