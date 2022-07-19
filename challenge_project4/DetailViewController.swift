//
//  DetailViewController.swift
//  challenge_project4
//
//  Created by Madiapps on 19/07/2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    var selectedUrl: String!
    var websites: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRightButtonOnNavbar()
        showToolbar()
        loadUrl()
    }
    
    // From init view
    func loadUrl() {
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://" + selectedUrl)!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // Show right button on navbar
    func showRightButtonOnNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }
    
    // Open Alert for choosing site
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // Load url page from alert action
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            return
        }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func showToolbar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressBtn = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "Go Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goNext = UIBarButtonItem(title: "Go Next", style: .plain, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressBtn,spacer, goBack, spacer, goNext, spacer, refresher]
        navigationController?.isToolbarHidden = false
        
        // Observe webview.estimated
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
