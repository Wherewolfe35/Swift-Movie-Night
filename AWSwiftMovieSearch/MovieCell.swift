//
//  MovieCell.swift
//  AWSwiftMovieSearch
//
//  Created by Aaron Wolfe on 4/7/20.
//  Copyright © 2020 Aaron Wolfe. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var backdrop: UIImageView!
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        overview.text = movie.overview
//        backdrop.path
    }
}

