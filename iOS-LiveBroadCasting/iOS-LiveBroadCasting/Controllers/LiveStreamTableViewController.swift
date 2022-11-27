//
//  LiveStreamTableViewController.swift
//  iOS-LiveBroadCasting
//
//  Created by 姚佳宏MacBookPro on 2022/11/27.
//

import UIKit
import AVKit
import AVFoundation
import CoreGraphics

class LiveStreamTableViewController: UITableViewController {
    
    static let PresentPlayerViewControllerSegueID = "presentPlayerViewControllerSegueIdentifier"
    
    private var playerViewController: AVPlayerViewController?
    
    let streamList:[Stream] = [
      
        Stream(title: "Test HLS Stream",
               descriprion: "Description for Test HLS Stream",
               stream_url: "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8",
               thumbnail_url: nil),
        Stream(title: "Demo 影片1",
               descriprion: "Description for LocalHost Stream",
               stream_url: "http://localhost/hls/IMG_0001.m3u8",
               thumbnail_url: "http://localhost/hls/thumb_0001.png"),
        Stream(title: "Demo 影片2",
               descriprion: "Description for LocalHost Stream",
               stream_url: "http://localhost/hls/IMG_0002.m3u8",
               thumbnail_url: "http://localhost/hls/thumb_0002.png"),
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if playerViewController != nil {
            // The view reappeared as a results of dismissing an AVPlayerViewController.
            // Perform cleanup.
            playerViewController?.player = nil
            playerViewController = nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return streamList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveStreamTableViewCellIdentifier", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = streamList[indexPath.row].title
        content.secondaryText = streamList[indexPath.row].descriprion ?? ""
        if let imageURL = streamList[indexPath.row].thumbnail_url,
           let url = URL(string: imageURL){
            do{
                let data = try Data(contentsOf: url)
                let content_thumb = UIImage(data: data)
                 
                content.image = UIImage(data: data)
                let itemSize = CGSize(width: 40, height: 40)
            
                UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
                 
                let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
                content.image?.draw(in: imageRect)
                content.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }catch{
                print(error)
            }
        }
        content.textProperties.color = .orange
        cell.backgroundColor = .clear
        cell.contentConfiguration = content

        return cell
    }
    
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == LiveStreamTableViewController.PresentPlayerViewControllerSegueID{
           guard let playerViewController = segue.destination as? AVPlayerViewController  else{return}
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let streamURLString = streamList[indexPath.row].stream_url
                if let playURL = URL(string: streamURLString){
                    playerViewController.player = AVPlayer(url: playURL)
                }
            }
           
       
        }
             
    }
    

}
