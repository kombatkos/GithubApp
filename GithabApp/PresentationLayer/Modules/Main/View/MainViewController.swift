//
//  MainViewController.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import UIKit
import SafariServices

protocol MainViewControllerViewModelType {
    var delegate: MainViewControllerDelegate? { get set }
    func numberOfSection() -> Int?
    func numberOfRowsInSection(_ section: Int) -> Int
    func getViewModelForHeader(_ section: Int) -> MainSectionHeaderViewModelType?
    func getViewModelForCell(_ indexPath: IndexPath) -> MainCellViewModelType?
    func getRepo(for indexPath: IndexPath) -> Repos?
    func searchUsers(_ searchText: String?)
}

protocol MainViewControllerDelegate: AnyObject {
    func reloadData()
    func presentAlert(_ alertVC: UIAlertController)
    func runSpiner()
    func stopSpiner()
}

class MainViewController: UIViewController {
    
    var viewModel: MainViewControllerViewModelType?
    weak var assembly: IPresentationAssembly?
    
    @IBOutlet weak var bannerView: UIView?
    @IBOutlet weak var searchButton: UIButton?
    @IBOutlet weak var spiner: UIActivityIndicatorView?
    @IBOutlet weak var scrollButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    private var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner?.isHidden = true
        viewModel?.delegate = self
        setSearchController()
        configureTableView()
        configureNavigationBar()
        configureUIElements()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.bannerView?.alpha = 0
            self.navigationController?.navigationBar.isHidden = false
            let searchTextField = self.searchController.value(forKey: "searchTextField") as? UITextField
            searchTextField?.becomeFirstResponder()
        } completion: { _ in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func scrollButtonPresed(_ sender: UIButton) {
        tableView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func configureUIElements() {
        scrollButton?.alpha = 0
        spiner?.color = .red
        searchButton?.layer.cornerRadius = 10
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Github users"
        let image: UIImage = #imageLiteral(resourceName: "download").withRenderingMode(.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: image,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(openDownloadList))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func openDownloadList() {
        guard let vc = assembly?.createDownloadListViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureTableView() {
        let nibCell = UINib(nibName: String(describing: MainCell.self), bundle: nil)
        tableView?.register(nibCell, forCellReuseIdentifier: MainCell.reuseId)
        
        let nibHeader = UINib(nibName: String(describing: MainSectionHeader.self), bundle: nil)
        tableView?.register(nibHeader, forHeaderFooterViewReuseIdentifier: MainSectionHeader.reuseId)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

extension MainViewController: MainViewControllerDelegate {
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    func runSpiner() {
        spiner?.isHidden = false
        spiner?.startAnimating()
    }
    
    func stopSpiner() {
        spiner?.isHidden = true
        spiner?.stopAnimating()
        showAlert(title: "Download completed", message: "")
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.reuseId, for: indexPath) as? MainCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.viewModel = self.viewModel?.getViewModelForCell(indexPath)
        return cell
    }
    
    func presentAlert(_ alertVC: UIAlertController) {
        present(alertVC, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainSectionHeader.reuseId) as? MainSectionHeader
        
        header?.viewModel = self.viewModel?.getViewModelForHeader(section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        
        presentSafariViewController(indexPath)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let contentOffset = tableView?.contentOffset else { return }
        
        if(velocity.y < -2) && (contentOffset.y > 0) {
            UIView.animate(withDuration: 0.5) { self.scrollButton?.alpha = 1 }
        } else {
            UIView.animate(withDuration: 0.5) { self.scrollButton?.alpha = 0 }
        }
    }
    
    private func presentSafariViewController(_ indexPath: IndexPath) {
        let repo = viewModel?.getRepo(for: indexPath)
        guard let urlString = repo?.htmlUrl,
              let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    private func setSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView?.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel?.searchUsers(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
}
