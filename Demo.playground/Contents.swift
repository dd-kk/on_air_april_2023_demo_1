import Foundation

extension ProductDto {
    static var sampleJSONAllValid: Data {
        let jsonString = "{\"active\":true,\"restriction\":\"inaccessible\",\"code\":\"product\"}"
        return jsonString.data(using: .utf8)!
    }
    static var sampleJSONIncludesInvalid: Data {
        let jsonString = "{\"active\":true,\"restriction\":\"blocked\",\"code\":\"product\"}"
        return jsonString.data(using: .utf8)!
    }
}

extension ResourcesDto {
    static var sampleJSONAllValid: Data {
        let jsonString = "{\"navigators\":[\"apple_maps\",\"google_maps\"]}"
        return jsonString.data(using: .utf8)!
    }
    static var sampleJSONIncludesInvalid: Data {
        let jsonString = "{\"navigators\":[\"apple_maps\",\"google_map\"]}"
        return jsonString.data(using: .utf8)!
    }
    
    var validNavigators: [Navigators] {
        navigators?.compactMap({ $0.wrappedValue }) ?? []
    }
}


if let model = try? JSONDecoder().decode(ProductDto.self, from: ProductDto.sampleJSONAllValid) {
    print("ProductDto")
    print("Parsed valid restriction: \(model.restriction!)")
}
print("==============================")


if let model = try? JSONDecoder().decode(ProductDto.self, from: ProductDto.sampleJSONIncludesInvalid) {
    print("ProductDto")
    print("Parsed invalid restriction: \(model.restriction)")
}
print("==============================")


if let model = try? JSONDecoder().decode(ResourcesDto.self, from: ResourcesDto.sampleJSONAllValid) {
    print("ResourcesDto")
    print("Parsed valid navigators: \(model.validNavigators)")
}
print("==============================")

if let model = try? JSONDecoder().decode(ResourcesDto.self, from: ResourcesDto.sampleJSONIncludesInvalid) {
    print("ResourcesDto")
    print("Parsed valid navigators: \(model.validNavigators)")
}
print("==============================")
