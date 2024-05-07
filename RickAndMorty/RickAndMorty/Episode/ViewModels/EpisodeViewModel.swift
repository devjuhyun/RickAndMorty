//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

final class EpisodeViewModel {
    @Published var episodes: [[Episode]] = []
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        Task {
            do {
                for s in 1...5 {
                    let response: Response<Episode> = try await requestManager.perform(APIRequest.getEpisodes(season: s))
                    episodes.append(response.results)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
