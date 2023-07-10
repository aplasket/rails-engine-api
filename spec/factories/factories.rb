FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
    invoices
  end

  factory :invoice do
    status {[packaged,returned,shipped].sample}
    merchant
    customer
  end

  factory :merchant do
    name {Faker::Space.galaxy}
    invoices
    items
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {[failed,success].sample}
    credit_card_number {Faker::Finance.credit_card}
    credit_card_expiration_date {Faker::Date.between(from: '2023-09-23', to: '2030-09-25')}
    invoice
  end

  factory :invoice_item do
    quantity {Faker::Number.within(range: 1..1000)}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    item
    invoice
  end
end