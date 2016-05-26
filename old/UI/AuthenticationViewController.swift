//
//  AuthenticationViewController.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/29/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import UIKit

@objc(SBAuthenticationViewController)
public class AuthenticationViewController: UIViewController, UIWebViewDelegate {
    
    private var webView: UIWebView!
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        precondition(Client.App?.redirectURI != nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        
        webView = UIWebView()
        webView.delegate = self
        webView.scalesPageToFit = true
        view.addSubview(webView)
        
        [.Left, .Right, .Top, .Bottom]
            .forEach { (attribute: NSLayoutAttribute) in
                view.addConstraint(NSLayoutConstraint(
                    item: webView,
                    attribute: attribute,
                    relatedBy: .Equal,
                    toItem: view,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0)
                )
            }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    public func reload() {
        let urlString = "https://stagebloc.com/connect?client_id=\(Client.App?.clientID)&response_type=code&redirect_uri=\(Client.App?.redirectURI)"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        webView.loadRequest(request)
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return request.URL?.absoluteString.hasPrefix("https://stagebloc.com/connect") ?? false
    }
}