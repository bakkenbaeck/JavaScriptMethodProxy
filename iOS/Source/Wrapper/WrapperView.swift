import UIKit
import WebKit

protocol WrapperViewDelegate: class {
}

class WrapperView: UIView {
    weak var viewDelegate: WrapperViewDelegate?

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()

        let view = WKWebView(frame: self.frame, configuration: config)
        view.navigationDelegate = self
        view.alpha = 0
        view.scrollView.isScrollEnabled = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }()

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.hidesWhenStopped = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.webView)
        self.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.center = self.center
        self.activityIndicatorView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.webView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}

extension WrapperView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Workaround: Even though this delegate is called, there could still be some things
        // remaining to be loaded before being able to display everything.
        let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.activityIndicatorView.stopAnimating()
            UIView.animate(withDuration: 0.5, animations: {
                self.webView.alpha = 1.0
            })
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // TODO: Display error
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                UIApplication.shared.openURL(url)
            }
        }
        
        decisionHandler(.allow)
    }
}
