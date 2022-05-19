// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: yandex/cloud/ai/stt/v2/stt_service.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
    get {return _config ?? Yandex_Cloud_Ai_Stt_V2_RecognitionConfig()}
    set {_config = newValue}
  }
  /// Returns true if `config` has been explicitly set.
  var hasConfig: Bool {return self._config != nil}
  /// Clears the value of `config`. Subsequent reads from it will return its default value.
  mutating func clearConfig() {self._config = nil}

  var audio: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio {
    get {return _audio ?? Yandex_Cloud_Ai_Stt_V2_RecognitionAudio()}
    set {_audio = newValue}
  }
  /// Returns true if `audio` has been explicitly set.
  var hasAudio: Bool {return self._audio != nil}
  /// Clears the value of `audio`. Subsequent reads from it will return its default value.
  mutating func clearAudio() {self._audio = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig? = nil
  fileprivate var _audio: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio? = nil
}

struct Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var chunks: [Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var streamingRequest: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.OneOf_StreamingRequest? = nil

  var config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
    get {
      if case .config(let v)? = streamingRequest {return v}
      return Yandex_Cloud_Ai_Stt_V2_RecognitionConfig()
    }
    set {streamingRequest = .config(newValue)}
  }

  var audioContent: Data {
    get {
      if case .audioContent(let v)? = streamingRequest {return v}
      return Data()
    }
    set {streamingRequest = .audioContent(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_StreamingRequest: Equatable {
    case config(Yandex_Cloud_Ai_Stt_V2_RecognitionConfig)
    case audioContent(Data)

  #if !swift(>=4.1)
    static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.OneOf_StreamingRequest, rhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.OneOf_StreamingRequest) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.config, .config): return {
        guard case .config(let l) = lhs, case .config(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.audioContent, .audioContent): return {
        guard case .audioContent(let l) = lhs, case .audioContent(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var chunks: [Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_RecognitionAudio {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var audioSource: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio.OneOf_AudioSource? = nil

  var content: Data {
    get {
      if case .content(let v)? = audioSource {return v}
      return Data()
    }
    set {audioSource = .content(newValue)}
  }

  var uri: String {
    get {
      if case .uri(let v)? = audioSource {return v}
      return String()
    }
    set {audioSource = .uri(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_AudioSource: Equatable {
    case content(Data)
    case uri(String)

  #if !swift(>=4.1)
    static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio.OneOf_AudioSource, rhs: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio.OneOf_AudioSource) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.content, .content): return {
        guard case .content(let l) = lhs, case .content(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.uri, .uri): return {
        guard case .uri(let l) = lhs, case .uri(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var specification: Yandex_Cloud_Ai_Stt_V2_RecognitionSpec {
    get {return _specification ?? Yandex_Cloud_Ai_Stt_V2_RecognitionSpec()}
    set {_specification = newValue}
  }
  /// Returns true if `specification` has been explicitly set.
  var hasSpecification: Bool {return self._specification != nil}
  /// Clears the value of `specification`. Subsequent reads from it will return its default value.
  mutating func clearSpecification() {self._specification = nil}

  var folderID: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _specification: Yandex_Cloud_Ai_Stt_V2_RecognitionSpec? = nil
}

struct Yandex_Cloud_Ai_Stt_V2_RecognitionSpec {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var audioEncoding: Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.AudioEncoding = .unspecified

  /// 8000, 16000, 48000 only for pcm
  var sampleRateHertz: Int64 = 0

  /// code in BCP-47
  var languageCode: String = String()

  var profanityFilter: Bool = false

  var model: String = String()

  /// If set true, tentative hypotheses may be returned as they become available (final=false flag)
  /// If false or omitted, only final=true result(s) are returned.
  /// Makes sense only for StreamingRecognize requests.
  var partialResults: Bool = false

  var singleUtterance: Bool = false

  /// Used only for long running recognize.
  var audioChannelCount: Int64 = 0

  /// This mark allows disable normalization text
  var rawResults: Bool = false

  /// Rewrite text in literature style (default: false)
  var literatureText: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum AudioEncoding: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case unspecified // = 0

    /// 16-bit signed little-endian (Linear PCM)
    case linear16Pcm // = 1
    case oggOpus // = 2

    /// transcription only
    case mp3 // = 3
    case UNRECOGNIZED(Int)

    init() {
      self = .unspecified
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .linear16Pcm
      case 2: self = .oggOpus
      case 3: self = .mp3
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .linear16Pcm: return 1
      case .oggOpus: return 2
      case .mp3: return 3
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  init() {}
}

#if swift(>=4.2)

extension Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.AudioEncoding: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.AudioEncoding] = [
    .unspecified,
    .linear16Pcm,
    .oggOpus,
    .mp3,
  ]
}

#endif  // swift(>=4.2)

struct Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var alternatives: [Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative] = []

  /// This flag shows that the received chunk contains a part of the recognized text that won't be changed.
  var final: Bool = false

  /// This flag shows that the received chunk is the end of an utterance.
  var endOfUtterance: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var alternatives: [Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative] = []

  var channelTag: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var text: String = String()

  var confidence: Float = 0

  var words: [Yandex_Cloud_Ai_Stt_V2_WordInfo] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Yandex_Cloud_Ai_Stt_V2_WordInfo {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var startTime: SwiftProtobuf.Google_Protobuf_Duration {
    get {return _startTime ?? SwiftProtobuf.Google_Protobuf_Duration()}
    set {_startTime = newValue}
  }
  /// Returns true if `startTime` has been explicitly set.
  var hasStartTime: Bool {return self._startTime != nil}
  /// Clears the value of `startTime`. Subsequent reads from it will return its default value.
  mutating func clearStartTime() {self._startTime = nil}

  var endTime: SwiftProtobuf.Google_Protobuf_Duration {
    get {return _endTime ?? SwiftProtobuf.Google_Protobuf_Duration()}
    set {_endTime = newValue}
  }
  /// Returns true if `endTime` has been explicitly set.
  var hasEndTime: Bool {return self._endTime != nil}
  /// Clears the value of `endTime`. Subsequent reads from it will return its default value.
  mutating func clearEndTime() {self._endTime = nil}

  var word: String = String()

  var confidence: Float = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _startTime: SwiftProtobuf.Google_Protobuf_Duration? = nil
  fileprivate var _endTime: SwiftProtobuf.Google_Protobuf_Duration? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionRequest: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionResponse: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.OneOf_StreamingRequest: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_RecognitionAudio: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_RecognitionAudio.OneOf_AudioSource: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_RecognitionSpec: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.AudioEncoding: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative: @unchecked Sendable {}
extension Yandex_Cloud_Ai_Stt_V2_WordInfo: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "yandex.cloud.ai.stt.v2"

extension Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LongRunningRecognitionRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "config"),
    2: .same(proto: "audio"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._config) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._audio) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._config {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._audio {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionRequest, rhs: Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionRequest) -> Bool {
    if lhs._config != rhs._config {return false}
    if lhs._audio != rhs._audio {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LongRunningRecognitionResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "chunks"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.chunks) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.chunks.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.chunks, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionResponse, rhs: Yandex_Cloud_Ai_Stt_V2_LongRunningRecognitionResponse) -> Bool {
    if lhs.chunks != rhs.chunks {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".StreamingRecognitionRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "config"),
    2: .standard(proto: "audio_content"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig?
        var hadOneofValue = false
        if let current = self.streamingRequest {
          hadOneofValue = true
          if case .config(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.streamingRequest = .config(v)
        }
      }()
      case 2: try {
        var v: Data?
        try decoder.decodeSingularBytesField(value: &v)
        if let v = v {
          if self.streamingRequest != nil {try decoder.handleConflictingOneOf()}
          self.streamingRequest = .audioContent(v)
        }
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    switch self.streamingRequest {
    case .config?: try {
      guard case .config(let v)? = self.streamingRequest else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }()
    case .audioContent?: try {
      guard case .audioContent(let v)? = self.streamingRequest else { preconditionFailure() }
      try visitor.visitSingularBytesField(value: v, fieldNumber: 2)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest, rhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest) -> Bool {
    if lhs.streamingRequest != rhs.streamingRequest {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".StreamingRecognitionResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "chunks"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.chunks) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.chunks.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.chunks, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse, rhs: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) -> Bool {
    if lhs.chunks != rhs.chunks {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionAudio: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".RecognitionAudio"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "content"),
    2: .same(proto: "uri"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Data?
        try decoder.decodeSingularBytesField(value: &v)
        if let v = v {
          if self.audioSource != nil {try decoder.handleConflictingOneOf()}
          self.audioSource = .content(v)
        }
      }()
      case 2: try {
        var v: String?
        try decoder.decodeSingularStringField(value: &v)
        if let v = v {
          if self.audioSource != nil {try decoder.handleConflictingOneOf()}
          self.audioSource = .uri(v)
        }
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    switch self.audioSource {
    case .content?: try {
      guard case .content(let v)? = self.audioSource else { preconditionFailure() }
      try visitor.visitSingularBytesField(value: v, fieldNumber: 1)
    }()
    case .uri?: try {
      guard case .uri(let v)? = self.audioSource else { preconditionFailure() }
      try visitor.visitSingularStringField(value: v, fieldNumber: 2)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio, rhs: Yandex_Cloud_Ai_Stt_V2_RecognitionAudio) -> Bool {
    if lhs.audioSource != rhs.audioSource {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".RecognitionConfig"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "specification"),
    2: .standard(proto: "folder_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._specification) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.folderID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._specification {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.folderID.isEmpty {
      try visitor.visitSingularStringField(value: self.folderID, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig, rhs: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig) -> Bool {
    if lhs._specification != rhs._specification {return false}
    if lhs.folderID != rhs.folderID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionSpec: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".RecognitionSpec"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "audio_encoding"),
    2: .standard(proto: "sample_rate_hertz"),
    3: .standard(proto: "language_code"),
    4: .standard(proto: "profanity_filter"),
    5: .same(proto: "model"),
    7: .standard(proto: "partial_results"),
    8: .standard(proto: "single_utterance"),
    9: .standard(proto: "audio_channel_count"),
    10: .standard(proto: "raw_results"),
    11: .standard(proto: "literature_text"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.audioEncoding) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.sampleRateHertz) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.languageCode) }()
      case 4: try { try decoder.decodeSingularBoolField(value: &self.profanityFilter) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.model) }()
      case 7: try { try decoder.decodeSingularBoolField(value: &self.partialResults) }()
      case 8: try { try decoder.decodeSingularBoolField(value: &self.singleUtterance) }()
      case 9: try { try decoder.decodeSingularInt64Field(value: &self.audioChannelCount) }()
      case 10: try { try decoder.decodeSingularBoolField(value: &self.rawResults) }()
      case 11: try { try decoder.decodeSingularBoolField(value: &self.literatureText) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.audioEncoding != .unspecified {
      try visitor.visitSingularEnumField(value: self.audioEncoding, fieldNumber: 1)
    }
    if self.sampleRateHertz != 0 {
      try visitor.visitSingularInt64Field(value: self.sampleRateHertz, fieldNumber: 2)
    }
    if !self.languageCode.isEmpty {
      try visitor.visitSingularStringField(value: self.languageCode, fieldNumber: 3)
    }
    if self.profanityFilter != false {
      try visitor.visitSingularBoolField(value: self.profanityFilter, fieldNumber: 4)
    }
    if !self.model.isEmpty {
      try visitor.visitSingularStringField(value: self.model, fieldNumber: 5)
    }
    if self.partialResults != false {
      try visitor.visitSingularBoolField(value: self.partialResults, fieldNumber: 7)
    }
    if self.singleUtterance != false {
      try visitor.visitSingularBoolField(value: self.singleUtterance, fieldNumber: 8)
    }
    if self.audioChannelCount != 0 {
      try visitor.visitSingularInt64Field(value: self.audioChannelCount, fieldNumber: 9)
    }
    if self.rawResults != false {
      try visitor.visitSingularBoolField(value: self.rawResults, fieldNumber: 10)
    }
    if self.literatureText != false {
      try visitor.visitSingularBoolField(value: self.literatureText, fieldNumber: 11)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_RecognitionSpec, rhs: Yandex_Cloud_Ai_Stt_V2_RecognitionSpec) -> Bool {
    if lhs.audioEncoding != rhs.audioEncoding {return false}
    if lhs.sampleRateHertz != rhs.sampleRateHertz {return false}
    if lhs.languageCode != rhs.languageCode {return false}
    if lhs.profanityFilter != rhs.profanityFilter {return false}
    if lhs.model != rhs.model {return false}
    if lhs.partialResults != rhs.partialResults {return false}
    if lhs.singleUtterance != rhs.singleUtterance {return false}
    if lhs.audioChannelCount != rhs.audioChannelCount {return false}
    if lhs.rawResults != rhs.rawResults {return false}
    if lhs.literatureText != rhs.literatureText {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.AudioEncoding: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "AUDIO_ENCODING_UNSPECIFIED"),
    1: .same(proto: "LINEAR16_PCM"),
    2: .same(proto: "OGG_OPUS"),
    3: .same(proto: "MP3"),
  ]
}

extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpeechRecognitionChunk"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "alternatives"),
    2: .same(proto: "final"),
    3: .standard(proto: "end_of_utterance"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.alternatives) }()
      case 2: try { try decoder.decodeSingularBoolField(value: &self.final) }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.endOfUtterance) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.alternatives.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.alternatives, fieldNumber: 1)
    }
    if self.final != false {
      try visitor.visitSingularBoolField(value: self.final, fieldNumber: 2)
    }
    if self.endOfUtterance != false {
      try visitor.visitSingularBoolField(value: self.endOfUtterance, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk, rhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionChunk) -> Bool {
    if lhs.alternatives != rhs.alternatives {return false}
    if lhs.final != rhs.final {return false}
    if lhs.endOfUtterance != rhs.endOfUtterance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpeechRecognitionResult"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "alternatives"),
    2: .standard(proto: "channel_tag"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.alternatives) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.channelTag) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.alternatives.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.alternatives, fieldNumber: 1)
    }
    if self.channelTag != 0 {
      try visitor.visitSingularInt64Field(value: self.channelTag, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult, rhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionResult) -> Bool {
    if lhs.alternatives != rhs.alternatives {return false}
    if lhs.channelTag != rhs.channelTag {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpeechRecognitionAlternative"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "text"),
    2: .same(proto: "confidence"),
    3: .same(proto: "words"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.text) }()
      case 2: try { try decoder.decodeSingularFloatField(value: &self.confidence) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.words) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.text.isEmpty {
      try visitor.visitSingularStringField(value: self.text, fieldNumber: 1)
    }
    if self.confidence != 0 {
      try visitor.visitSingularFloatField(value: self.confidence, fieldNumber: 2)
    }
    if !self.words.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.words, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative, rhs: Yandex_Cloud_Ai_Stt_V2_SpeechRecognitionAlternative) -> Bool {
    if lhs.text != rhs.text {return false}
    if lhs.confidence != rhs.confidence {return false}
    if lhs.words != rhs.words {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Yandex_Cloud_Ai_Stt_V2_WordInfo: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".WordInfo"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "start_time"),
    2: .standard(proto: "end_time"),
    3: .same(proto: "word"),
    4: .same(proto: "confidence"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._startTime) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._endTime) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.word) }()
      case 4: try { try decoder.decodeSingularFloatField(value: &self.confidence) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._startTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._endTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    if !self.word.isEmpty {
      try visitor.visitSingularStringField(value: self.word, fieldNumber: 3)
    }
    if self.confidence != 0 {
      try visitor.visitSingularFloatField(value: self.confidence, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Yandex_Cloud_Ai_Stt_V2_WordInfo, rhs: Yandex_Cloud_Ai_Stt_V2_WordInfo) -> Bool {
    if lhs._startTime != rhs._startTime {return false}
    if lhs._endTime != rhs._endTime {return false}
    if lhs.word != rhs.word {return false}
    if lhs.confidence != rhs.confidence {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
