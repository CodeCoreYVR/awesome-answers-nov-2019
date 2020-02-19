FactoryBot.define do
  factory :gift do
    sender_id { 1 }
    receiver_id { 1 }
    amount { 2.5 }
    txn_id { 'myTxnString' }
  end
end
