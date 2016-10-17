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
    
    @IBOutlet weak var tableView: UITableView!
    var movieType: MovieType?
    var movies: [Movie]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.reuseID)

        self.fetchData()
        // Do any additional setup after loading the view.
    }

    func urlToFetch() -> URL {
        var url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
        
        if (self.movieType == MovieType.TopRated) {
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        }
        
        return URL(string: url)!
    }
    
    func fetchData() {
        let url = urlToFetch()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                if let resultArr = dictionary?["results"] as? [[String:Any]] {
                    DispatchQueue.main.async {
                        self.movies = Movie.moviesFrom(array: resultArr)
                    }
                }
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180;
    }
}

extension MoviesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseID) as! MovieTableViewCell
        if let movie = movies?[indexPath.row] {
            cell.configureCellWith(movie: movie);
        }
        return cell;
    }
}

