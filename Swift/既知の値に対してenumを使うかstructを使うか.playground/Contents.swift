/// 元々は以下の記事の内で記載されているenum+structを試すためだった
/// https://zenn.dev/matsuji/articles/1461b0ac90c95f
/// しかしコメント欄にある@dynamicMemberLookupとkeypathの組み合わせを見た時にそれぞれについて理解が浅かったので試してみたくなった

/// まずはenum+struct
enum Item: Identifiable {
    case account, report, term

    struct Model {
        let id: String
        let title: String
        let iconName: String
        let description: String?
    }

    var id: String { model.id }

    var model: Model {
        switch self {
        case .account: return .account
        case .report: return .report
        case .term: return .term
        }
    }
}

extension Item.Model {
    static let account = Item.Model(
        id: "account",
        title: "アカウント設定",
        iconName: "person",
        description: nil
    )

    static let report = Item.Model(
        id: "report",
        title: "お問い合わせ",
        iconName: "exclamationmark.bubble",
        description: "バグ報告/要望はこちらから"
    )

    static let term = Item.Model(
        id: "term",
        title: "利用規約",
        iconName: "doc",
        description: nil
    )
}

func ttt() {
    let id = Item.term.model.id
    print(id)
}

/// @dynamicMemberLookupとkeyPath
@dynamicMemberLookup enum Item2: Identifiable {
    case account, report, term

    struct Model {
        let id: String
        let title: String
        let iconName: String
        let description: String?
    }

    var id: String { model.id }
    subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
        model[keyPath: keyPath]
    }

    var model: Model {
        switch self {
        case .account:
            return .account
        case .report:
            return .report
        case .term:
            return .term
        }
    }
}

extension Item2.Model {
    static let account = Item2.Model(
        id: "account",
        title: "アカウント設定",
        iconName: "person",
        description: nil
    )

    static let report = Item2.Model(
        id: "report",
        title: "お問い合わせ",
        iconName: "exclamationmark.bubble",
        description: "バグ報告/要望はこちらから"
    )

    static let term = Item2.Model(
        id: "term",
        title: "利用規約",
        iconName: "doc",
        description: nil
    )
}

func ttt2() {
    let title = Item2.report.title
    print(title)
}

ttt()
ttt2()
