//
//  MoviesViewController.swift
//  flixter
//
//  Created by Kinjal Reetoo on 4/12/20.
//  Copyright © 2020 Kinjal Reetoo. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // these 2 lines call the 2 table view func (located at the bottom) first to initialize / set up the empty table view
        // can also do this later after fetching data from api to directly set up + populate at the same time so we dont have to call reloadData()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            // after loading the data from the api, we call the 2 table view func (at the bottom) one more time to populate the table view w data we just fetched
            self.tableView.reloadData()

            print(self.movies)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // # of rows in table view = # of times this func is gonna be called
        
        // dequeueReusableCell: reuse cells that are currently off screen to optimize memory
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL+posterPath)
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
       }
       
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
