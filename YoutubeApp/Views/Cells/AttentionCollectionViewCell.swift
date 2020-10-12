//
//  AttentionCollectionViewCell.swift
//  YoutubeApp
//
//  Created by user on 2020/08/02.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Nuke

class AttentionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var videoItem: Item? {
        didSet {

            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }

            videoTitleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description

            channelTitleLabel.text = videoItem?.channel?.items[0].snippet.title

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
