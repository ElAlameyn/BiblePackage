//
//  File.swift
//  
//
//  Created by Артем Калинкин on 02.11.2023.
//


import Foundation

// MARK: - Default
public enum Printer {
  public static func error(_ error: Error) { Swift.print("🛑 Error 🛑: \(error)") }

  public static func error(_ error: String) { Swift.print("🛑 Error 🛑: \(error)") }

  public static func response(_ response: URLResponse) { Swift.print("🔸 Response 🔸: \(response)") }

  public static func result<A>(_ result: A) { Swift.print("🟢 Result 🟢: \(result) ") }

  public static func resultArray<A>(_ result: [A]?) {
    guard let result else { return }
    for (i, el) in result.enumerated() {
      Swift.print("🟢 el \(i) 🟢: \(el)")
    }
  }

  public static func label<A>(_ label: String, result: A) { Swift.print("🔹 \(label) 🔹 : \(result) ") }
}

// MARK: - JSON Printing
public extension Printer {
  static func printJsonFromData(_ data: Data) {
    if let object = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) {
      Swift.print("🔹🔹🔹 JSON Object: \(object) 🔹🔹🔹")
    } else {
      Swift.print("🔺🔺🔺 JSON Object is failed to serialize 🔺🔺🔺")
    }
  }

  static func prettyPrint<Value: Encodable>(_ v: Value) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
      let jsonData = try encoder.encode(v)
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        Printer.label("\(Value.self)", result: jsonString)
      }
    } catch {
      Printer.error(error)
    }
  }
}

