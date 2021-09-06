// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: yandex/cloud/operation/operation.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// An Operation resource. For more information, see [Operation](/docs/api-design-guide/concepts/operation).
public struct Yandex_Cloud_Operation_Operation {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID of the operation.
  public var id: String {
    get {return _storage._id}
    set {_uniqueStorage()._id = newValue}
  }

  /// Description of the operation. 0-256 characters long.
  public var description_p: String {
    get {return _storage._description_p}
    set {_uniqueStorage()._description_p = newValue}
  }

  /// Creation timestamp.
  public var createdAt: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._createdAt ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._createdAt = newValue}
  }
  /// Returns true if `createdAt` has been explicitly set.
  public var hasCreatedAt: Bool {return _storage._createdAt != nil}
  /// Clears the value of `createdAt`. Subsequent reads from it will return its default value.
  public mutating func clearCreatedAt() {_uniqueStorage()._createdAt = nil}

  /// ID of the user or service account who initiated the operation.
  public var createdBy: String {
    get {return _storage._createdBy}
    set {_uniqueStorage()._createdBy = newValue}
  }

  /// The time when the Operation resource was last modified.
  public var modifiedAt: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._modifiedAt ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._modifiedAt = newValue}
  }
  /// Returns true if `modifiedAt` has been explicitly set.
  public var hasModifiedAt: Bool {return _storage._modifiedAt != nil}
  /// Clears the value of `modifiedAt`. Subsequent reads from it will return its default value.
  public mutating func clearModifiedAt() {_uniqueStorage()._modifiedAt = nil}

  /// If the value is `false`, it means the operation is still in progress.
  /// If `true`, the operation is completed, and either `error` or `response` is available.
  public var done: Bool {
    get {return _storage._done}
    set {_uniqueStorage()._done = newValue}
  }

  /// Service-specific metadata associated with the operation.
  /// It typically contains the ID of the target resource that the operation is performed on.
  /// Any method that returns a long-running operation should document the metadata type, if any.
  public var metadata: SwiftProtobuf.Google_Protobuf_Any {
    get {return _storage._metadata ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_uniqueStorage()._metadata = newValue}
  }
  /// Returns true if `metadata` has been explicitly set.
  public var hasMetadata: Bool {return _storage._metadata != nil}
  /// Clears the value of `metadata`. Subsequent reads from it will return its default value.
  public mutating func clearMetadata() {_uniqueStorage()._metadata = nil}

  /// The operation result.
  /// If `done == false` and there was no failure detected, neither `error` nor `response` is set.
  /// If `done == false` and there was a failure detected, `error` is set.
  /// If `done == true`, exactly one of `error` or `response` is set.
  public var result: OneOf_Result? {
    get {return _storage._result}
    set {_uniqueStorage()._result = newValue}
  }

  /// The error result of the operation in case of failure or cancellation.
  public var error: Google_Rpc_Status {
    get {
      if case .error(let v)? = _storage._result {return v}
      return Google_Rpc_Status()
    }
    set {_uniqueStorage()._result = .error(newValue)}
  }

  /// The normal response of the operation in case of success.
  /// If the original method returns no data on success, such as Delete,
  /// the response is [google.protobuf.Empty].
  /// If the original method is the standard Create/Update,
  /// the response should be the target resource of the operation.
  /// Any method that returns a long-running operation should document the response type, if any.
  public var response: SwiftProtobuf.Google_Protobuf_Any {
    get {
      if case .response(let v)? = _storage._result {return v}
      return SwiftProtobuf.Google_Protobuf_Any()
    }
    set {_uniqueStorage()._result = .response(newValue)}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// The operation result.
  /// If `done == false` and there was no failure detected, neither `error` nor `response` is set.
  /// If `done == false` and there was a failure detected, `error` is set.
  /// If `done == true`, exactly one of `error` or `response` is set.
  public enum OneOf_Result: Equatable {
    /// The error result of the operation in case of failure or cancellation.
    case error(Google_Rpc_Status)
    /// The normal response of the operation in case of success.
    /// If the original method returns no data on success, such as Delete,
    /// the response is [google.protobuf.Empty].
    /// If the original method is the standard Create/Update,
    /// the response should be the target resource of the operation.
    /// Any method that returns a long-running operation should document the response type, if any.
    case response(SwiftProtobuf.Google_Protobuf_Any)

  #if !swift(>=4.1)
    public static func ==(lhs: Yandex_Cloud_Operation_Operation.OneOf_Result, rhs: Yandex_Cloud_Operation_Operation.OneOf_Result) -> Bool {
      switch (lhs, rhs) {
      case (.error(let l), .error(let r)): return l == r
      case (.response(let l), .response(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "yandex.cloud.operation"

extension Yandex_Cloud_Operation_Operation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Operation"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "description"),
    3: .standard(proto: "created_at"),
    4: .standard(proto: "created_by"),
    5: .standard(proto: "modified_at"),
    6: .same(proto: "done"),
    7: .same(proto: "metadata"),
    8: .same(proto: "error"),
    9: .same(proto: "response"),
  ]

  fileprivate class _StorageClass {
    var _id: String = String()
    var _description_p: String = String()
    var _createdAt: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _createdBy: String = String()
    var _modifiedAt: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _done: Bool = false
    var _metadata: SwiftProtobuf.Google_Protobuf_Any? = nil
    var _result: Yandex_Cloud_Operation_Operation.OneOf_Result?

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _id = source._id
      _description_p = source._description_p
      _createdAt = source._createdAt
      _createdBy = source._createdBy
      _modifiedAt = source._modifiedAt
      _done = source._done
      _metadata = source._metadata
      _result = source._result
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularStringField(value: &_storage._id)
        case 2: try decoder.decodeSingularStringField(value: &_storage._description_p)
        case 3: try decoder.decodeSingularMessageField(value: &_storage._createdAt)
        case 4: try decoder.decodeSingularStringField(value: &_storage._createdBy)
        case 5: try decoder.decodeSingularMessageField(value: &_storage._modifiedAt)
        case 6: try decoder.decodeSingularBoolField(value: &_storage._done)
        case 7: try decoder.decodeSingularMessageField(value: &_storage._metadata)
        case 8:
          var v: Google_Rpc_Status?
          if let current = _storage._result {
            try decoder.handleConflictingOneOf()
            if case .error(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._result = .error(v)}
        case 9:
          var v: SwiftProtobuf.Google_Protobuf_Any?
          if let current = _storage._result {
            try decoder.handleConflictingOneOf()
            if case .response(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._result = .response(v)}
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if !_storage._id.isEmpty {
        try visitor.visitSingularStringField(value: _storage._id, fieldNumber: 1)
      }
      if !_storage._description_p.isEmpty {
        try visitor.visitSingularStringField(value: _storage._description_p, fieldNumber: 2)
      }
      if let v = _storage._createdAt {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }
      if !_storage._createdBy.isEmpty {
        try visitor.visitSingularStringField(value: _storage._createdBy, fieldNumber: 4)
      }
      if let v = _storage._modifiedAt {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      }
      if _storage._done != false {
        try visitor.visitSingularBoolField(value: _storage._done, fieldNumber: 6)
      }
      if let v = _storage._metadata {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
      }
      switch _storage._result {
      case .error(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      case .response(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
      case nil: break
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Yandex_Cloud_Operation_Operation, rhs: Yandex_Cloud_Operation_Operation) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._id != rhs_storage._id {return false}
        if _storage._description_p != rhs_storage._description_p {return false}
        if _storage._createdAt != rhs_storage._createdAt {return false}
        if _storage._createdBy != rhs_storage._createdBy {return false}
        if _storage._modifiedAt != rhs_storage._modifiedAt {return false}
        if _storage._done != rhs_storage._done {return false}
        if _storage._metadata != rhs_storage._metadata {return false}
        if _storage._result != rhs_storage._result {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}