extension Sequence {

    func uniqueElements<T: Equatable>(identifier: (Iterator.Element) -> T) -> [Iterator.Element] {
        return reduce([]) { uniqueElements, element in
            if uniqueElements.contains(where: { identifier($0) == identifier(element) }) {
                return uniqueElements
            } else {
                return uniqueElements + [element]
            }
        }

    }

}

extension Sequence where Iterator.Element: Equatable {

    var uniqueElements: [Iterator.Element] {
        return self.reduce([]) { uniqueElements, element in
            uniqueElements.contains(element) ? uniqueElements : uniqueElements + [element]
        }
    }

}
