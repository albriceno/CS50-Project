//
//  resourcespage.swift
//  CS50
//
//  Created by Alejandra Briceno on 11/26/25.
//

import Foundation
import SwiftUI

//creation of a suite where the app can speciically save the preference (language choice based on toggle)
extension UserDefaults {
    static let resourcesPreviewSuite: UserDefaults = {
        let suiteName = "ResourcesViewPreviewSuite"
        return UserDefaults(suiteName: suiteName) ?? .standard
    }()
}



// this view renders resources in a clean, readable format that mirrors the layout used in report details
struct ResourceDetailView: View {
    let title: String
    let text: String
    let isSpanish: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Icon + title side-by-side (matches ReportDetailView)
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.accentColor)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(isSpanish ? "Información del recurso" : "Resource Information")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text(isSpanish ? "Descripción" : "Description")
                            .font(.subheadline.bold())
                        
                        Text(text)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)
                
                Spacer(minLength: 8)
            }
            .padding(.top, 12)
        }
        .background(Color("AppBackground").ignoresSafeArea())
    }
}

//actual declaration of the ResourcesView page in the app that integrates the suite just created with a newly created property that defaults to english, until the toggle is "toggle'd"
struct ResourcesView_Real: View {
    init() {
        print(">>> ResourcesView INITIALIZED")
    }
    @AppStorage("resourcesLanguage", store: UserDefaults.resourcesPreviewSuite)
    private var resourcesLanguageCode: String = "en"
    
    // here the "enumeration" or "enum" type is created and given two cases; english and spanish
    private enum ResourcesLanguage { case english, spanish }
    
    
    
    // stores the hard-coded text as English or Spanish
    private var language: ResourcesLanguage {
        resourcesLanguageCode == "es" ? .spanish : .english
    }
    
    private var isSpanish: Bool { language == .spanish }
    
    
    
    // binding that reflects the user's language preference
    private var spanishBinding: Binding<Bool> {
        Binding(
            get: { resourcesLanguageCode == "es" },
            set: { resourcesLanguageCode = $0 ? "es" : "en" }
        )
    }
    
    
    // this pill toggle controls the EN / ES language switch and visually matches the rounded UI theme
    private var languageTogglePill: some View {
        HStack(spacing: 0) {
            Text("EN")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(resourcesLanguageCode == "en" ? Color(.systemBackground) : .clear)
                .cornerRadius(14)
                .onTapGesture { resourcesLanguageCode = "en" }
            
            Text("ES")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(resourcesLanguageCode == "es" ? Color(.systemBackground) : .clear)
                .cornerRadius(14)
                .onTapGesture { resourcesLanguageCode = "es" }
        }
        .font(.caption.bold())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(radius: 1)
    }
    
    
    
    // this helper creates simple list row content without additional card styling
    // (the List itself will handle the card appearance)
    private func resourceCard(title: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.headline)
            
            Text(isSpanish ? "Toca para más detalles" : "Tap for more details")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    
    // the header at the top mimics the report tab, featuring a centered bubble and toggle beneath it
    private var headerBubble: some View {
        ZStack {
            
            // the title bubble sits slightly higher to mirror the visual lead seen in the report screen
            Text(isSpanish ? "Recursos" : "Resources")
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 22)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2, y: 1)
                )
                .offset(y: -10)
            
            
            // the toggle is positioned slightly lower to prevent overlap and improve readability
            HStack {
                Spacer()
                languageTogglePill
                    .offset(y: 12)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 6)
        .padding(.top, 3)
        .background(Color("AppBackground").ignoresSafeArea(edges: .top))
    }
    
    
    
    
    //this initial line defines the entire list on the resources page
    var body: some View {
        ZStack {
            
            // background color is consistent with the rest of the app
            Color("AppBackground")
                .ignoresSafeArea()
            
            
            List {
                
                
                // KNOW YOUR RIGHTS SECTION
                Section(language == .english ? "Know Your Rights" : "Conozca Sus Derechos") {
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: language == .english ? "Constitutional Rights" : "Derechos Constitucionales",
                            text: language == .english
                            ? "Under the 4th and 5th Amendments..."
                            : "NO ABRA LA PUERTA si un agente...",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title:
                                        language == .english ? "Constitutional Rights" : "Derechos Constitucionales"
                        )
                    }
                }
                
                
                
                // COMMUNITY ORGANIZATIONS SECTION
                Section(language == .english
                        ? "Boston/Cambridge Community Organizations"
                        : "Organizaciones Comunitarias de Boston/Cambridge") {
                    
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: "MIRA",
                            text: isSpanish
                            ? "Número de teléfono: 617-350-5480"
                            : "Phone Number: 617-350-5480",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title:
                                        "Massachusetts Immigrant & Refugee Advocacy Coalition (MIRA)"
                        )
                    }
                    
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: "CIRC",
                            text: isSpanish ? "Número de teléfono: 617-349-4396"
                            : "Phone Number: 617-349-4396",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title:
                                        "Commission on Immigrant Rights & Citizenship (CIRC)"
                        )
                    }
                    
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: "Inquilinos Boricuas en Acción",
                            text: isSpanish ? "Número de teléfono: 617-927-1707"
                            : "Phone Number: 617-927-1707",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title: "Inquilinos Boricuas en Acción")
                    }
                    
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: isSpanish
                            ? "Centro de Apoyo a la Organización de Inmigrantes"
                            : "Center to Support Immigrant Organizing",
                            text: isSpanish ? "Número de teléfono: 617-742-5165"
                            : "Phone Number: 617-742-5165",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title:
                                        isSpanish
                                     ? "Centro de Apoyo a la Organización de Inmigrantes"
                                     : "Center to Support Immigrant Organizing"
                        )
                    }
                }
                
                
                
                // LEGAL SERVICES SECTION
                Section(language == .english ? "Legal Services" : "Servicios Legales") {
                    
                    NavigationLink {
                        ResourceDetailView(
                            title: language == .english
                            ? "Greater Boston Legal Services – Immigration Unit"
                            : "Servicios Legales de Boston – Inmigración",
                            text: isSpanish ? "Número de teléfono: 617-371-1234"
                            : "Phone Number: 617-371-1234",
                            isSpanish: isSpanish
                        )
                    } label: {
                        resourceCard(title:
                                        language == .english
                                     ? "Greater Boston Legal Services – Immigration Unit"
                                     : "Greater Boston Legal Services – Unidad de Inmigración"
                        )
                    }
                }
            }
            
            
            // these modifiers remove the nested-card visual effect and let cards sit on the background like in the reports tab
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        
        
        // the native navigation bar is hidden so the custom header can lead visually
        .toolbar(.hidden, for: .navigationBar)
        
        // the custom header is placed at the top in the safe area
        .safeAreaInset(edge: .top) {
            headerBubble
        }
    }
}
