//
//  FavoriteAnimalTableViewCell.swift
//  YoutubeApp
//
//  Created by user on 2020/10/21.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import Nuke

class FavoriteAnimalTableViewCell: UITableViewCell {



    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var videoItem: Item? {
        didSet {

            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
    // チャンネルイメージは使わないためコメントアウト
    //            if let channelUrl = URL(string: videoItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
    //                Nuke.loadImage(with: channelUrl, into: channelImageView)
    //            }

            titleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description

        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
