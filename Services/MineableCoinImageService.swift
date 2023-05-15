//
//  MineableCoinImageService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import SwiftUI
import Combine


class MineableCoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: MineableCoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init (coin: MineableCoinModel) {
        self.coin = coin
        self.imageName = coin.symbol
        getCoinImage()
    }
    
    private func downloadCoinImage() {

        guard let url = URL(string: coin.image ?? "") else {
            return
        }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self,
                    let downloadedImage = returnedImage   else {return}
                //print ("try something else")
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
    private func getCoinImage() {
        //print (imageName, folderName)
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            //print ("Retrieved Image from Local")
        } else if let savedImage = fileManager.getImage(imageName: imageName.lowercased(), folderName: folderName) {
            image = savedImage
            //print ("Retrieved Image from Local")
        }
        else {
            downloadCoinImage()
            //print ("Download \(imageName.lowercased()) from Internet.")
        }
    }

}
