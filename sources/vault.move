module vault::vault{
    use sui::dynamic_object_field as ofield;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, ID, UID};
    use sui::coin::{Self, Coin};
    use sui::bag::{Bag, Self};
    use sui::table::{Table, Self};
    use sui::transfer;

    struct Bet has key, store{
        id: UID,
        bet: u64,
        answer: string::String,
    }  

    struct QuestionSession<phantom COIN> has key {
        id: UID,
        pot: Bet,
        payments: Table<address, Coin<COIN>>
    }
    
    public entry fun mint(ctx: &mut TxContext, bet_amount: &mut u64, answer_provided: string::String) {
        let object = Bet {
            id: object::new(ctx),
            bet: bet_amount,
            answer: answer_provided
        };
        transfer::transfer(object, tx_context::sender(ctx));
    }

    public entry fun create<COIN>(ctx: &mut TxContext) {
        let id = object::new(ctx);
        let pot = Bet::new(ctx);
        let payments = table::new<address, Coin<COIN>>(ctx);
        transfer::share_object(QuestionSession<COIN> { 
            id, 
            pot,
            payments
        })
    }
}