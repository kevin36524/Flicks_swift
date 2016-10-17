//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Kevin Balvantkumar Patel on 10/16/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {
    static let reuseID = "movieTableViewCellReuseIdentifier"
    var movie: Movie?
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith(movie: Movie) {
        self.movie = movie;
        self.movieTitle.text = movie.title
        self.movieOverview.text = movie.overview
        if let posterPath = movie.poster_path {
            let url = "http://image.tmdb.org/t/p/w500/\(posterPath)"
            self.movieImageView.setImageWith(URL(string: url)!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
