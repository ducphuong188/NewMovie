//
//  UserVC.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class UserVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return table
    }()
    var headerView: userHeaderView?
    var arrString: [String] = ["Thông tin tài khoản", "Nhập mã kích hoạt", "Lịch sử giao dịch","Quản lý thiết bị","Dịch vụ đã mua","Giới thiệu bạn bè","Hỗ trợ"]
    var imageString: [String] = ["person.crop.circle.fill","keyboard","cart","stove","rectangle.on.rectangle.angled","person.fill.checkmark" ,"phone.fill"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: UIBarAppearance())
        title = "Tài khoản"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        headerView = userHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
        tableView.tableHeaderView = headerView
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }


}
extension UserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.configure(image: imageString[indexPath.row], title: arrString[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
