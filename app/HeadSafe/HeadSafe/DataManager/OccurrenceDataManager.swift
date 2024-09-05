//
//  DataManager.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 05/09/24.
//

import Foundation
import Combine

struct OccurrenceDataManager {
    private static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let occurrencesCacheURL = documentsDirectory.appendingPathComponent("occurrencesCache").appendingPathExtension("plist")
    static let occurrencesDidChange = PassthroughSubject<Void, Never>()
    
    // Save occurrence by appending to existing occurrences in cache
    static func saveOccurrence(_ occurrence: Occurrence) {
        var occurrences = loadOccurrences() ?? []
        occurrences.append(occurrence)
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(occurrences)
            try data.write(to: occurrencesCacheURL, options: .noFileProtection)
            occurrencesDidChange.send()
        } catch {
            print("Erro ao salvar ocorrência")
        }
    }
    
    // Save multiple occurrences (append to existing)
    static func saveOccurrences(_ newOccurrences: [Occurrence]) {
        var occurrences = loadOccurrences() ?? []
        occurrences.append(contentsOf: newOccurrences)
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(occurrences)
            try data.write(to: occurrencesCacheURL, options: .noFileProtection)
            occurrencesDidChange.send()
        } catch {
            print("Erro ao salvar ocorrências")
        }
    }
    
    // Load occurrences from cache
    static func loadOccurrences() -> [Occurrence]? {
        do {
            let data = try Data(contentsOf: occurrencesCacheURL)
            let decoder = PropertyListDecoder()
            return try decoder.decode([Occurrence].self, from: data)
        } catch {
            print("Erro ao carregar ocorrências")
            return nil
        }
    }
    
    // Clear occurrences cache
    static func clearCache() {
        do {
            try FileManager.default.removeItem(at: occurrencesCacheURL)
            occurrencesDidChange.send()
        } catch {
            print("Erro ao limpar o cache de ocorrências")
        }
    }
}
