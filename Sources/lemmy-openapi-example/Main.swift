//
// Copyright (c) 2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@main
struct Main {
    static func main() async throws {
        let client = Client(
            serverURL: try Servers.server1(),
            configuration: .init(dateTranscoder: LemmyDateTranscoder()),
            transport: URLSessionTransport()
        )
        let response = try await client.getPosts(query: .init(GetPosts: .init(type_: .All)))
        let posts = try response.ok.body.json.posts
        let postsString = posts
            .map {
                "\($0.post.name) by \($0.creator.name)"
            }
            .joined(separator: "\n")
        print(postsString)
    }
}
