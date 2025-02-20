//
//  OpenAIRequest.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import Foundation

struct OpenAIRequest: Codable {
    let model: String
    let prompt: String
    let max_tokens: Int
    let temperature: Double
}

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        let text: String
    }
    let choices: [Choice]
}

class OpenAIAPI {
    static let shared = OpenAIAPI()
    private init() {}

    // あらかじめOpenAIから取得したAPIキー
    let apiKey = "YOUR_API_KEY"

    func fetchTaskBreakdown(prompt: String) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let requestBody = OpenAIRequest(
            model: "text-davinci-003", // モデルを指定
            prompt: prompt,
            max_tokens: 150,
            temperature: 0.7
        )

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        return response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}

