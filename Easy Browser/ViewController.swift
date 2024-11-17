//
//  ViewController.swift
//  Easy Browser
//
//  Created by Smit Patel on 16/11/24.
//

import UIKit
import WebKit



class ViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    private var webView: WKWebView!
    private let initialURLString = "https://www.youtube.com/"
    
    var websites = ["https://www.youtube.com/" , "https://www.zomato.com/" , "https://www.apple.com/"]
    
    var progressView: UIProgressView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressBarButton = UIBarButtonItem(customView: progressView)
        
        
        
        toolbarItems = [back , forward , spacer , progressBarButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        
        
        
        
        setupWebView()
        //loadInitialURL()
        
        
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac , animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: action.title!)
        print(url)
        webView.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
      }
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction , decisionHandler : @escaping (WKNavigationActionPolicy)-> Void) {
//        let url = navigationAction.request.url
//        
//        if let host = url?.host {
//            for website in websites {
//                if host.contains(website)
//                {
//                    decisionHandler(.allow)
//                    return
//                }
//            }
//            
//        }
//        
//        decisionHandler(.cancel)
//    }
    
    
    // MARK: - Web View Setup
    private func setupWebView() {
        // Initialize and configure the web view
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the web view to the view hierarchy
        view.addSubview(webView)
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Web View Configuration
    private func loadInitialURL() {
        // Safely unwrap the URL
        guard let url = URL(string: websites[0]) else {
            print("Invalid URL string: \(websites[0])")
            return
        }
        
        // Create and load the URL request
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Enable navigation gestures
        webView.allowsBackForwardNavigationGestures = true
    }
}

