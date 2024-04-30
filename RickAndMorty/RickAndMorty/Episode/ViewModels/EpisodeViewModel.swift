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
    private var canLoadMorePages = true
    private var page = 0
    var searchText = ""
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        guard canLoadMorePages else { return }
        
        Task {
            do {
                page += 1
                let response: Response<Episode> = try await requestManager.perform(APIRequest.getEpisodes(page: page, name: searchText))
                episodes.append(contentsOf: response.results)
                canLoadMorePages = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func resetEpisodes() {
        canLoadMorePages = true
        searchText = ""
        episodes = []
        page = 0
    }
}
