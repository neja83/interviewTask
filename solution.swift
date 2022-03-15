import Foundation

// MARK: - Task

struct Product {
    let id: String; // unique identifier
    let name: String;
    let producer: String;
}

protocol Shop {
    /**
     Adds a new product object to the Shop.
     - Parameter product: product to add to the Shop
     - Returns: false if the product with same id already exists in the Shop, true – otherwise.
     */
    func addNewProduct(product: Product) -> Bool
    
    /**
     Deletes the product with the specified id from the Shop.
     - Returns: true if the product with same id existed in the Shop, false – otherwise.
     */
    func deleteProduct(id: String) -> Bool
    
    /**
     - Returns: 10 product names containing the specified string.
     If there are several products with the same name, producer's name is added to product's name in the format "<producer> - <product>",
     otherwise returns simply "<product>".
     */
    func listProductsByName(searchString: String) -> Set<String>
    
    /**
     - Returns: 10 product names whose producer contains the specified string,
     result is ordered by producers.
     */
    func listProductsByProducer(searchString: String) -> [String]
}

// MARK: - Solution

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: - Implementation
class ShopImpl: Shop {
    
    private var products: [String: Product] = [:]

    private final let countOfResponce: Int = 10
    
    func addNewProduct(product: Product) -> Bool {
        if !products.keys.contains(product.id) {
            products[product.id] = product
            return true
        }
        return false
    }
    
    func deleteProduct(id: String) -> Bool {
        if products.keys.contains(id) {
            products.removeValue(forKey: id)
            return true
        }
        return false
    }
    
    func listProductsByName(searchString: String) -> Set<String> {
        var result = Set<String>([])
        
        let filteredProducts = products
            .filter({ $0.value.name.contains(searchString) })
            .prefix(countOfResponce)
        
//        MARK: we can use a map method, but it makes it hard to understand code
//        return Set(filteredProducts.map { product -> String in
//            if filteredProducts.filter({ $0.value.name == product.value.name }).count > 1 {
//                return "\(product.value.producer) - \(product.value.name)"
//            } else {
//                return product.value.name
//            }
//        })
        
        for product in filteredProducts {
            let countOfProduct = filteredProducts.filter({ $0.value.name == product.value.name })

            if countOfProduct.count > 1 {
                result.insert("\(product.value.producer) - \(product.value.name)")
            } else {
                result.insert(product.value.name)
            }
        }

        return result
    }
    
    func listProductsByProducer(searchString: String) -> [String] {
       products
        .filter({ $0.value.producer.contains(searchString) })
        .prefix(countOfResponce)
        .sorted(by: { $0.value.producer < $1.value.producer })
        .map({ $0.value.name })
    }
    
}
