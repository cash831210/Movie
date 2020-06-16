//
//  MovieViewController.swift
//  Movie
//
//  Created by 莊鎧旭 on 2020/5/31.
//  Copyright © 2020 Cash. All rights reserved.
//

import UIKit
import Foundation

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var moviesArray = [MoviesData]()
    var index = 0
    
    //拿到電影資訊
    func getMoiveInfo(){
        let urlStr = "https://api.themoviedb.org/3/discover/movie?api_key=c4a29efb1edc8463c88073ce91895eed&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2020"
        if let url = URL(string: urlStr) {
            
            URLSession.shared.dataTask(with: url) { (data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = data , let moviesData = try? decoder.decode(Film.self, from: data){
                    
                    self.moviesArray = moviesData.results
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        print(moviesData)
                    }
                }
                
            }.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movieList = moviesArray[indexPath.row]
        
        cell.titleLabel.text = movieList.title
        cell.releaseDataLabel.text = movieList.release_date
        
        if let vote = movieList.vote_average {
            cell.voteLabel.text = String(vote)
        }
        
        if let imageAddress = movieList.poster_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
                let task = URLSession.shared.dataTask(with: imageURL){(data, response, error ) in
                    if let data = data{
                        DispatchQueue.main.async {
                            cell.movieImageView.image = UIImage(data:data)
                        }
                    }
                }
                task.resume()
                
            }
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //呼叫拿到電影Data的方法
        getMoiveInfo()
        
    }
}
