//
//  MembersJoinedVC.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit

class MembersJoinedVC: UIViewController {
    
    private var memberJoinedVM: MemberJoinedViewModel = MemberJoinedViewModel()
    var eventRef: String = String()
    private var page: Int = Int()

    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        tableView.register(UINib.init(nibName: TABLE_VIEW_CELL.MembersJoinedCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MembersJoinedCell.rawValue)
        
        page = 1
        let request = ListRequest(eventRef: eventRef, page: page)
        memberJoinedVM.fetchJoinedMemberList(request: request)
        
        memberJoinedVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.memberJoinedVM.success.value {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension MembersJoinedVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memberJoinedVM.joinedMemberList.value.count == DocumentDefaultValues.Empty.int {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        }
        else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return memberJoinedVM.joinedMemberList.value.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MembersJoinedCell.rawValue, for: indexPath) as? MembersJoinedCell else { return UITableViewCell() }
        let memberInfo = memberJoinedVM.joinedMemberList.value[indexPath.row]
        cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.profilePlaceHolder.rawValue, urlString: AppImageUrl.average + memberInfo.picture)
        cell.nameLbl.text = memberInfo.name
        cell.emailLbl.text = memberInfo.email
        cell.createrView.isHidden = true
        if memberInfo.creator {
            cell.createrView.isHidden = false
        }
        return cell
    }
}
