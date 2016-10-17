//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Kevin Balvantkumar Patel on 10/16/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    enum MovieType {
        case TopRated, NowPlaying
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var movieType: MovieType?
    var movies: [Movie]?
    var refreshControl: UIRefreshControl!
    var filteredMovies: [Movie]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.reuseID)
        self.searchBar.delegate = self

        self.addRefreshController()
        
        self.fetchData(completion: nil)
        // Do any additional setup after loading the view.
    }

    func addRefreshController() {
        self.refreshControl = UIRefreshControl();
        self.refreshControl.addTarget(self, action: #selector(refresh) , for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0);
    }
    
    func refresh() {
        self.refreshControl.beginRefreshing()
        self.fetchData() {
            self.refreshControl.endRefreshing()
            self.searchBar.text = "";
        };
    }
    
    func urlToFetch() -> URL {
        var url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
        
        if (self.movieType == MovieType.TopRated) {
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        }
        
        return URL(string: url)!
    }
    
    func fetchData(completion:(()->Void)?) {
        let url = urlToFetch()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                if let resultArr = dictionary?["results"] as? [[String:Any]] {
                    DispatchQueue.main.async {
                        self.movies = Movie.moviesFrom(array: resultArr)
                        self.filteredMovies = self.movies
                        if let completion = completion {
                            completion();
                        }
                    }
                }
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MoviesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180;
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies?.filter ({
            (($0.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)) != nil)
        })
    }
}

extension MoviesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseID) as! MovieTableViewCell
        if let movie = filteredMovies?[indexPath.row] {
            cell.configureCellWith(movie: movie);
        }
        return cell;
    }
}

