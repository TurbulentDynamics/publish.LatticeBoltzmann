import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct LatticeBoltzmann: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://LatticeBoltzmann.com")!
    var title = "Turbulent Dynamics Lattice Boltzmann"
    var name = "Turbulent Dynamics Lattice Boltzmann"
    var description = "Turbulent Dynamics Lattice Boltzmann"
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
    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }
}//ext
struct MyHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        let items = context.allItems(sortedBy: \.date, order: .descending)
        return HTML( .head(for: index, on: context.site), //head
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
                        ) { item in
                            .if(item.title == "first-post",
                            .li(
                                .class("non-listing"),
                                .article(
                                    //                                    .h1(.text(item.title)),
                                    //                                    .p(.text(item.description)),
                                    .contentBody(item.body)
                                )//article
                            )//li
                            )
                        }
                    )//ul
                ), //wrapper
                .footer(for: context.site)
            )//body

        )//html
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML( .head(for: section, on: context.site)
//              .footer(for: context.site)
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
         let items = context.allItems(sortedBy: \.date, order: .descending)

       return HTML( .head(for: item, on: context.site),
            .body(
                .header(
                    .wrapper(
                        .nav(
                            .class("website-name"),
                            .a(.href("/"),

                               .text(context.site.name)),

                            .ul(
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
                ),
                .footer(for: context.site)
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
extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHtmlFactory(),
            resourcePaths: ["Resources/theme/styles.css"]
        )
    }
}
// This will generate your website using the built-in Foundation theme:
try LatticeBoltzmann().publish(withTheme: .myTheme,
                               additionalSteps: [
                                
    .deploy(using: .gitHub("Lattice-Boltzmann/Lattice-Boltzmann.github.io"))]
)
