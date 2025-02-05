//
//  APIClient.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct APIClient {
  var bookMetadata: @Sendable (_ url: String) async throws -> Metadata
}

extension APIClient: TestDependencyKey {
  static let previewValue = Self( bookMetadata: { _ in .mock } )
  static let testValue = Self( bookMetadata: { _ in .mock } )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

extension APIClient: DependencyKey {
  static let liveValue = APIClient(
    bookMetadata: { urlString in
        guard let url = URL.init(string: urlString) else {
            throw APIClientError.invalidUrl(urlString: urlString)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try jsonDecoder.decode(Metadata.self, from: data)
    }
  )
}

// MARK: - Private helpers

private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  return decoder
}()

enum APIClientError: Error {
    case invalidUrl(urlString: String)
}
