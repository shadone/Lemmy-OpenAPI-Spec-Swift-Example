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
    static let authorizationMiddleware = AuthorizationMiddleware()

    static func main() async throws {
        let client = Client(
            serverURL: try Servers.server1(),
            configuration: .init(dateTranscoder: LemmyDateTranscoder()),
            transport: URLSessionTransport(),
            middlewares: [authorizationMiddleware]
        )

        let response = try await client.getPosts(query: .init(type_: .All))
        let posts = try response.ok.body.json.posts
        let postsString = posts
            .map {
                "\($0.post.name) by \($0.creator.name)"
            }
            .joined(separator: "\n")
        print(postsString)
    }

    static func createPost(client: Client) async throws {
        let jwt = try await {
            print("### login")
            let response = try await client.login(body: .json(.init(
                username_or_email: "your-username-goes-here",
                password: "your-password-goes-here"
            )))

            return try response.ok.body.json.jwt!
        }()

        await authorizationMiddleware.setToken(jwt)

        let logins = try await {
            print("### listLogins")
            let response = try await client.listLogins()
            return try response.ok.body.json
        }()
        print(logins)

        let communities = try await {
            print("### listCommunities")
            let response = try await client.listCommunities(query: .init(
                type_: .All
            ))
            return try response.ok.body.json.communities
        }()
        print(communities)

        if let testCommunity = communities.first(where: { $0.community.name == "test" }) {
            _ = try await client.createPost(body: .json(.init(
                name: "Hello world",
                community_id: testCommunity.community.id,
                body: "Hello"
            )))
        }
    }
}
