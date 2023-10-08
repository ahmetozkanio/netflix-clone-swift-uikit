//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 5.08.2023.
//

import UIKit

class DownloadsViewController: UIViewController {

    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadedTable: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row].originalName ?? titles[indexPath.row].originalTitle ?? "Unkown"
        guard let image = titles[indexPath.row].posterPath else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: title, posterURL: image))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.originalTitle ?? title.originalName else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    
                    vc.configure(with: TitlePreviewViewModel(
                        item: Title(id: Int(title.id), mediaType: title.mediaType, originalName: title.originalName, originalTitle: title.originalTitle, posterPath: title.posterPath, overview: title.overview, voteCount: Int(title.voteCount), releaseDate: title.releaseDate, voteAverage: Double(title.voteAverage)
                                   ),
                        youtubeView: videoElement)
                    )
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
             
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
           
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self]result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
               
            }
        default:
            break
        }
    }
}
