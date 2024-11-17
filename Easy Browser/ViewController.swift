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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [spacer, refresh,spacer]
        navigationController?.isToolbarHidden = false
        
        
        setupWebView()
        loadInitialURL()
    }
    
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "youtube.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac , animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://"+action.title!)
        webView.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    
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
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Web View Configuration
    private func loadInitialURL() {
        // Safely unwrap the URL
        guard let url = URL(string: initialURLString) else {
            print("Invalid URL string: \(initialURLString)")
            return
        }
        
        // Create and load the URL request
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Enable navigation gestures
        webView.allowsBackForwardNavigationGestures = true
    }
}

