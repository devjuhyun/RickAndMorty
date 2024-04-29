//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

final class EpisodeViewModel {
    @Published var episodes: [Episode] = []
    private let requestManager: RequestManagerProtocol
    private var shouldfetchEpisodes = true
    private var isFetching = false
    private var page = 0
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        guard shouldfetchEpisodes else { return }
        
        Task {
            do {
                page += 1
                let response: Response<Episode> = try await requestManager.perform(APIRequest.getEpisodes(page: page))
                episodes.append(contentsOf: response.results)
                shouldfetchEpisodes = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
