//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 7.10.2023.
//

import UIKit
import WebKit

final class TitlePreviewViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Kurtlar Vadisi"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 20
        label.text = "This is the best movie!"
        
        return label
    }()
    
    private let downloadButton: UIButton = {
       
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
       
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    private var titleItem: Title?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
         
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()

        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 24),
            downloadButton.widthAnchor.constraint(equalToConstant: 128),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

    }
    
    func configure(with model: TitlePreviewViewModel) {
        self.titleItem = model.item
        titleLabel.text = model.item.originalTitle ?? ""
        overviewLabel.text =  model.item.overview ?? ""
        
        guard let url = URL(string: "https://www.youtube.com/embed/\( model.youtubeView.id?.videoId ?? "")") else {
            return
        }
        
        webView.load(URLRequest(url: url))
        
        DataPersistenceManager.shared.downloadedBeforeCheckingDatabase(model: model.item) { [weak self] result in
            switch result {
            case .success(let value):
                self?.downloadButton.isHidden = value
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func downloadButtonTapped() {
        guard let titleItem = self.titleItem else { return }
        DataPersistenceManager.shared.downloadTitleWith(model: titleItem) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                self.downloadButton.isHidden = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
