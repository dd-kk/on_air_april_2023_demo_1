#!/usr/bin/ruby

def find_enums(text)
    enums = text.to_enum(:scan, /public enum (.+): String, Codable {/)
        .map { Regexp.last_match }
        .map { |m| m.captures.first }
end

def wrap_enums(text)
	enums = find_enums(text)
	if enums && enums.length > 0
        enums.each do |enum|
            text = wrap_enum_property(text, enum)
            text = wrap_array_of_enums_property(text, enum)
        end
    end
    return text
end

def wrap_enum_property(text, enum)
    regexp_result = text.match(/public var (.+): #{enum}?/)
    if regexp_result
        variable = regexp_result.captures.first
        variable_s = variable.to_s
        if variable_s.length > 0
            text.gsub!("public var #{variable_s}: #{enum}?", "@DecodeUnknownAsNil public var #{variable_s}: #{enum}?")
        end
    end
    return text
end

def wrap_array_of_enums_property(text, enum)
    text.gsub!("[#{enum}]", "[DecodeUnknownAsNil<#{enum}>]")
    return text
end

def generate_enum_property_wrapper
    File.open("src/EnumPropertyWrapper.swift", "w") do |file|
        file.write("@propertyWrapper
public struct DecodeUnknownAsNil<Enum: RawRepresentable> where Enum.RawValue: Codable {
    public var wrappedValue: Enum?
    
    public init(wrappedValue: Enum? = nil) {
        self.wrappedValue = wrappedValue
    }
}

extension DecodeUnknownAsNil : Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Enum.RawValue.self)
        wrappedValue = Enum(rawValue: raw)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue?.rawValue)
    }
}

public extension KeyedDecodingContainer {
    func decode<Enum>(_ type: DecodeUnknownAsNil<Enum>.Type, forKey key: Key) throws -> DecodeUnknownAsNil<Enum> {
        return try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
    }
}

extension DecodeUnknownAsNil: Equatable where Enum: Equatable {}
extension DecodeUnknownAsNil: Hashable where Enum: Hashable {}")
    end
end