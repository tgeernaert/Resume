//
//  JSONDataFetcher.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-19.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation

enum ResumeError: Error {
    /// The resume file was not found at the provided location
    case missingResource

    /// The URLSession did not return a valid response
    case invalidResponse

    /// The URLSession returned a error status code
    case errorStatus(Int)
}

/// Defines the interface to decode JSON into the required type
protocol JSONDataFetcher {
    /// Location of the JSON file
    var dataURL: URL { get set }

    /// fetches and decodes the JSON
    /// - parameter type: The type that we will try to decode into.
    /// - note: This can throw if the type doesn't match the JSON or if the JSON is malformed
    func fetch<Resume>(type: Resume.Type, completion:  @escaping (Result<Resume, Error>) -> Void) where Resume: Decodable
}

/// This version of the JSONDataFetcher simply accesses the bundled resume JSON.
struct BundledResumeDataFetcher: JSONDataFetcher {
    /// initialize the BundledResumeDataFetcher with the bundled "resume.json".
    /// - note: This will throw ResumeError.missingResource if the file is missing
    init() throws {
        guard let url = Bundle.main.url(forResource: "resume",
                                        withExtension: "json") else { throw ResumeError.missingResource }
        dataURL = url
    }

    // MARK: - JSONDataFetcher
    var dataURL: URL

    func fetch<Resume>(type: Resume.Type, completion:  @escaping (Result<Resume, Error>) -> Void) where Resume: Decodable {
        completion( Result { try JSONDecoder().decode(Resume.self, from: Data(contentsOf: dataURL)) } )
    }
}

struct GistResumeDataFetcher: JSONDataFetcher {
    // MARK: - JSONDataFetcher
    var dataURL = URL(string: "https://gist.githubusercontent.com/tgeernaert/ceb10b281131c2153b4f282f778e3f25/raw/52f076dbd1f99dacb4223b1fc4f09e34ea65d3a4/resume.json")!

    func fetch<Resume>(type: Resume.Type, completion: @escaping (Result<Resume, Error>) -> Void) where Resume: Decodable {
        let task = URLSession.shared.dataTask(with: dataURL) { data, response, error in
            DispatchQueue.main.async {
                completion( Result {
                    if let error = error { throw(error) }
                    guard let httpResponse = response as? HTTPURLResponse else { throw ResumeError.invalidResponse }
                    guard (200...299).contains(httpResponse.statusCode) else { throw ResumeError.errorStatus(httpResponse.statusCode) }
                    guard let data = data else { throw ResumeError.missingResource }

                    return try JSONDecoder().decode(Resume.self, from: data)
                })
            }
        }
        task.resume()
    }
}
