class Product < ApplicationRecord
    validates :price, presence: true
    validates :category, presence: true
    # category can only be one of the following 3 types
    enum category: { 
        book: 0, 
        car: 1, 
        software: 2 
    }
end
