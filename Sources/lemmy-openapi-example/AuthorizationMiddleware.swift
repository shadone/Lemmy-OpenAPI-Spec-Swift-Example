//
// Copyright (c) 2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

actor AuthorizationMiddleware: ClientMiddleware {
    private var token: String?

    init() { }

    func setToken(_ token: String) {
        self.token = token
    }

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        if let token {
            let authorization = HTTPField(name: .authorization, value: "Bearer \(token)")
            request.headerFields.append(authorization)
        }
        return try await next(request, body, baseURL)
    }
}
