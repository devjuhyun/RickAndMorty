//
//  SearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 5/7/24.
//

import Foundation

final class SearchResultViewModel {
    @Published public var episodes: [Episode] = []
    private let requestManager: RequestManagerProtocol
    private var canLoadMorePages = true
    private var page = 0
    public var searchText = ""
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    public func fetchEpisodes() {
        guard canLoadMorePages else { return }
        
        Task {
            do {
                page += 1
                let response: Response<Episode> = try await requestManager.perform(APIRequest.filterEpisodes(page: page, name: searchText))
                episodes.append(contentsOf: response.results)
                canLoadMorePages = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func resetEpisodes() {
        canLoadMorePages = true
        episodes = []
        page = 0
    }
}
