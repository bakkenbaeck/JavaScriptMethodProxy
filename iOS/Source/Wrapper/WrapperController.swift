import UIKit
class WrapperController: UIViewController {
    lazy var wrapperView: WrapperView = {
        let view = WrapperView(frame: UIScreen.main.bounds)
        view.viewDelegate = self

        return view
    }()

    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.wrapperView)

        let request = URLRequest(url: URL(string: self.baseURL)!)
        self.wrapperView.webView.load(request)
    }
}

extension WrapperController: WrapperViewDelegate {
}
