import SwiftUI
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    let modelContainer = ConfigureModelContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let input = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments?.first else {
            close()
            return
        }
        
        let textDataType = UTType.plainText.identifier
        let urlDataType = UTType.url.identifier
        
        if input.hasItemConformingToTypeIdentifier(urlDataType) {
            input.loadItem(forTypeIdentifier: urlDataType, options: nil) { (provided, error) in
                if let url = provided as? URL {
                    DispatchQueue.main.async {
                        self.showSmallShareView(with: url)
                    }
                } else {
                    self.close()
                }
            }
        } else if input.hasItemConformingToTypeIdentifier(textDataType) {
            input.loadItem(forTypeIdentifier: textDataType, options: nil) { (providedText, error) in
                if let text = providedText as? String {
                    DispatchQueue.main.async {
                        self.showSmallShareView(with: nil, note: text)
                    }
                } else {
                    self.close()
                }
            }
        } else {
            self.close()
        }
    }
    
    private var smallShareViewController: UIHostingController<AnyView>?

    func showSmallShareView(with url: URL? = nil, note: String? = nil) {
        let smallShareViewRoot = SmallShareView(note: note, extensionContext: extensionContext, url: url) {
            DispatchQueue.main.async {
                self.showShareView(with: url, note: note)
            }
        }.modelContainer(modelContainer)
        
        let smallShareView = UIHostingController(rootView: AnyView(smallShareViewRoot))
        smallShareViewController = smallShareView  // Store reference as UIHostingController<AnyView>
        
        self.addChild(smallShareView)
        self.view.addSubview(smallShareView.view)
        smallShareView.view.translatesAutoresizingMaskIntoConstraints = false
        smallShareView.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallShareView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        smallShareView.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        smallShareView.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        smallShareView.view.layer.cornerRadius = 15.0
        smallShareView.view.layer.masksToBounds = true
        
        smallShareView.didMove(toParent: self)
        
        smallShareView.view.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            smallShareView.view.alpha = 1.0
        }
    }

    func showShareView(with url: URL? = nil, note: String? = nil) {
        guard let smallShareView = smallShareViewController else {
            print("SmallShareView not found")
            return
        }

        smallShareView.willMove(toParent: nil)

        UIView.animate(withDuration: 0.3, animations: {
            smallShareView.view.alpha = 0.0
        }, completion: { _ in
            smallShareView.view.removeFromSuperview()
            smallShareView.removeFromParent()

            let shareViewRoot = ShareView(extensionContext: self.extensionContext, url: url, note: note).modelContainer(self.modelContainer)
            let shareView = UIHostingController(rootView: AnyView(shareViewRoot))
            
            self.addChild(shareView)
            self.view.addSubview(shareView.view)
            shareView.view.translatesAutoresizingMaskIntoConstraints = false
            shareView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            shareView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            shareView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            shareView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            
            shareView.didMove(toParent: self)

            shareView.view.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                shareView.view.alpha = 1.0
            }
        })
    }
    
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
