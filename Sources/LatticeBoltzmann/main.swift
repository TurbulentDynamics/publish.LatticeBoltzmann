import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct NiallOBroin: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://LatticeBoltzmann.com")!
    var title = "LatticeBoltzmann.github.io"
    var name = "Lattice Boltzmann"
    var description = "Some Photos and Words from Niall Ó Broin"
    var language: Language { .english }
    var imagePath: Path? { nil }
//    var socialMediaLinks: [SocialMediaLink] { [.location, .email, .linkedIn, .github, .twitter] }
}
private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }//wrapper
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                        )),
                    .p(.text(item.description))
                    ))
            }
        )
    }//itemList
}//ext
struct MyHtmlFactory<Site: Website>: HTMLFactory{
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        let items = context.allItems(sortedBy: \.date, order: .descending)
        return HTML( .head(for: index, on: context.site),//head
            .body(
                .header(
                    .wrapper(
                        .nav(
                            .class("website-name"),
                            .a(.href("/"),
                               
                               .text(context.site.name)),
                            
                            .ul(
                                .forEach(items) { item in
                                    .if(item.title != "first-post" && item.title != "Research",
                                        
                                        .li(.article(
                                            .a(.href(item.path),
                                               .text(item.title))
                                            )))
                                    
                                    
                                    
                                }
                            )
                        )
                    )
                ),
                .hr(),
                .wrapper(
                    .ul(
                        .class("listing"),
                        .forEach(
                            context.allItems(sortedBy: \.date, order: .descending)
                        ){ item in
                            .if(item.title == "first-post",
                            .li(
                                .class("non-listing"),
                                .article(
                                    //                                    .h1(.text(item.title)),
                                    //                                    .p(.text(item.description)),
                                    
                                    .contentBody(item.body)
                                )//artical
                            )//li
                            )
                        }
                    )//ul
                )//wrapper
            )//body
            
        )//html
    }
    
    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML( .head(for: section, on: context.site)
        )
    }
    
    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
         let items = context.allItems(sortedBy: \.date, order: .descending)
//        let items = context.allItems(sortedBy: \.date, order: .descending)
        
       return HTML( .head(for: item, on: context.site),
            .body(
                .header(
                    .wrapper(
                        .nav(
                            .class("website-name"),
                            .a(.href("/"),
                               
                               .text(context.site.name)),
                            
                            .ul(
                                
                                //                                                    .id("menuItems"),
                                .forEach(items) { item in
                                    .if(item.title != "first-post",
                                        .li(.article(
                                            .a(.href(item.path),
                                               .text(item.title))
                                            )))
                                }
                            )
                        )
                    )
                ),
                .hr(),
                .wrapper(
                    .article(
//                        .h1(item.title),
                        .contentBody(item.body)
                    )
                )
            )
            
        )
        
    }
    
    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}
extension Theme{
    static var myTheme :Theme{
        Theme(
            htmlFactory: MyHtmlFactory(),
            resourcePaths: ["Resources/MyTheme/styles.css"]
        )
    }
}
// This will generate your website using the built-in Foundation theme:
try NiallOBroin().publish(withTheme: .myTheme)


// deployedUsing: .gitHub("TurbulentDynamics/LatticeBoltzmann.github.io.publish")

