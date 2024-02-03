//
// Copyright (c) 2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import OpenAPIRuntime

struct LemmyDateTranscoder: DateTranscoder {
    func decode(_ value: String) throws -> Date {
        try Date(lemmyFormat: value)
    }
    func encode(_ value: Date) throws -> String {
        fatalError("not implemented")
    }
}
