//
//  ViewController.swift
//  Insta
//
//  Created by 18529728 on 09.04.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
	
	private lazy var loaderView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.isHidden = true
		view.startAnimating()
		return view
	}()

    var viewModel: ViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isAuthorization = userDefaults.value(forKey: Consts.UserDefaults.isAuthorization) as? Bool {
            if !isAuthorization {
                deleteCookies()
            }
        } else {
            settingAlert()
        }
        configWebView()
        configView()
    }

    @IBOutlet private weak var tableView: UITableView!
    private var webView: WKWebView = WKWebView()
    private let userDefaults = UserDefaults()

    private struct Consts {
        static let insUrl = "https://www.instagram.com/accounts/login/"
        static let sessionid = "sessionid"
        static let dsUserId = "ds_user_id"
        static let heightRow: CGFloat = 100
        static let logOutImageName = "person.crop.circle.badge.xmark"
        static let settingsImageName = "gearshape.fill"
        static let title = "Insta"

        struct UserDefaults {
            static let isAuthorization = "authorization"
        }
    }

    private func configView() {
        title = Consts.title
        let logOut = UIBarButtonItem(image: UIImage(systemName: Consts.logOutImageName), style: .done, target: self, action: #selector(logOutAction))
        let settings = UIBarButtonItem(image: UIImage(systemName: Consts.settingsImageName), style: .done, target: self, action: #selector(settingsAction))


        navigationItem.rightBarButtonItems = [logOut, settings]
        overrideUserInterfaceStyle = .light
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refresh(sender: UIRefreshControl) {
        viewModel?.updateDataBase {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }

    @objc private func logOutAction() {
        logOutAlert()
    }

    @objc private func settingsAction() {
        settingAlert()
    }

    private func settingAlert() {
        let alert = UIAlertController(title: "Сохранить авторизацию?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.userDefaults.setValue(true, forKey: Consts.UserDefaults.isAuthorization)
        }))

        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.userDefaults.setValue(false, forKey: Consts.UserDefaults.isAuthorization)
        }))

        self.present(alert, animated: true)
    }

    private func logOutAlert() {
        let alert = UIAlertController(title: "Выйти?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.deleteCookies()
            self.openInWebView(url: Consts.insUrl)
			self.updateView(isHiddenTable: true, isHiddenLoaderView: true)
        }))

        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    private func deleteCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
        configWebView()
    }
	
	private func updateView(isHiddenTable: Bool, isHiddenLoaderView: Bool) {
		webView.isHidden = !isHiddenTable
		tableView.isHidden = isHiddenTable
		tableView.reloadData()
		loaderView.isHidden = isHiddenLoaderView
	}

    private func getCookie() {
		updateView(isHiddenTable: false, isHiddenLoaderView: false)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.httpCookieStore.getAllCookies({ [weak self] cookies in
            guard
                let sessionId = cookies.first(where: { $0.name == Consts.sessionid })?.value,
                let dsUserId = cookies.first(where: { $0.name == Consts.dsUserId })?.value
            else {
				self?.updateView(isHiddenTable: true, isHiddenLoaderView: true)
				return
			}

            self?.viewModel = ViewModel(dsUserId: dsUserId, sessionId: sessionId)
            self?.viewModel?.updateDataBase(complition: { [weak self] in
                guard let self = self else { return }
				self.updateView(isHiddenTable: false, isHiddenLoaderView: true)
            })
        })
    }

    private func configWebView() {
        let preferences = WKPreferences()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        webView.removeFromSuperview()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
		loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
		view.addSubview(loaderView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        openInWebView(url: Consts.insUrl)
        webView.navigationDelegate = self
    }

    private func openInWebView(url: String) {
        guard let myURL = URL(string: url) else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { Consts.heightRow }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel?.dataBase.count ?? 0 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let model = viewModel?.dataBase[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier) as? UserCell
        else { return UITableViewCell() }
        cell.config(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let username = viewModel?.dataBase[indexPath.row].username,
            let url = URL(string: "https://www.instagram.com/\(username)/")
        else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - WKNavigationDelegate

extension ViewController: WKUIDelegate {

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        getCookie()
        decisionHandler(.allow)
    }
}
