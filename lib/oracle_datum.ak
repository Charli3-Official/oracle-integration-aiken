use aiken/cbor
use aiken/hash.{Blake2b_224, Hash}
use aiken/pairs
use aiken/transaction/credential.{Script}

pub type PriceMap =
  Pairs<Int, Int>

pub type PriceData {
  SharedData
  ExtendedData
  GenericData { price_map: PriceMap }
}

pub type OracleDatum {
  price_data: PriceData,
}

pub type ValidatorHash =
  Hash<Blake2b_224, Script>

// Function to get the price from PriceData
pub fn get_price(price_data: PriceData) -> Int {
  when price_data is {
    GenericData { price_map } ->
      when pairs.get_first(price_map, 0) is {
        Some(price) -> price
        None -> fail @"Price not found"
      }
    _ -> fail @"Invalid PriceData variant"
  }
}

// Function to get the timestamp from PriceData
pub fn get_timestamp(price_data: PriceData) -> Int {
  when price_data is {
    GenericData { price_map } ->
      when pairs.get_first(price_map, 1) is {
        Some(timestamp) -> timestamp
        None -> fail @"Timestamp not found"
      }
    _ -> fail @"Invalid PriceData variant"
  }
}

// Function to get the expiry from PriceData
pub fn get_expiry(price_data: PriceData) -> Int {
  when price_data is {
    GenericData { price_map } ->
      when pairs.get_first(price_map, 2) is {
        Some(expiry) -> expiry
        None -> fail @"Expiry not found"
      }
    _ -> fail @"Invalid PriceData variant"
  }
}

// Function to check if the oracle data is valid (not expired)
pub fn is_oracle_valid(oracle_datum: OracleDatum, current_time: Int) -> Bool {
  current_time <= get_expiry(oracle_datum.price_data)
}

// Function to get the price from OracleDatum
pub fn get_oracle_price(oracle_datum: OracleDatum) -> Int {
  get_price(oracle_datum.price_data)
}

// Function to get the timestamp from OracleDatum
pub fn get_oracle_timestamp(oracle_datum: OracleDatum) -> Int {
  get_timestamp(oracle_datum.price_data)
}

// Test for get_price()
test create_and_get_price() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 2723), Pair(1, 1720056807332), Pair(2, 1720078407332)],
      ),
    }
  get_price(datum.price_data) == 2723 && get_oracle_price(datum) == 2723
}

// Test for get_timestamp()
test create_and_get_timestamp() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 2723), Pair(1, 1720056807332), Pair(2, 1720078407332)],
      ),
    }
  get_timestamp(datum.price_data) == 1720056807332 && get_oracle_timestamp(
    datum,
  ) == 1720056807332
}

// Test for get_expiry()
test create_and_get_expiry() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 2723), Pair(1, 1720056807332), Pair(2, 1720078407332)],
      ),
    }
  get_expiry(datum.price_data) == 1720078407332
}

// Test for is_oracle_valid()
test is_oracle_valid_test() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 2723), Pair(1, 1720056807332), Pair(2, 1720078407332)],
      ),
    }
  is_oracle_valid(datum, 1720056807332) == True && is_oracle_valid(
    datum,
    1720078407333,
  ) == False
}

test oracle_datum_diagnostic() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 490850), Pair(1, 1707172554600), Pair(2, 1707176154600)],
      ),
    }
  let expected_diagnostic =
    @"121([_ 123([_ {_ 0: 490850, 1: 1707172554600, 2: 1707176154600 }])])"

  cbor.diagnostic(datum) == expected_diagnostic
}

test oracle_datum_serialise() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 490850), Pair(1, 1707172554600), Pair(2, 1707176154600)],
      ),
    }
  let expected_cbor =
    #"d8799fd87b9fa3001a00077d62011b0000018d7b69e768021b0000018d7ba0d5e8ffff"

  cbor.serialise(datum) == expected_cbor
}

test oracle_datum_getters() {
  let datum =
    OracleDatum {
      price_data: GenericData(
        [Pair(0, 2723), Pair(1, 1720056807332), Pair(2, 1720078407332)],
      ),
    }

  get_oracle_price(datum) == 2723 && get_oracle_timestamp(datum) == 1720056807332 && get_expiry(
    datum.price_data,
  ) == 1720078407332
}

test valid_price_data() {
  let valid_price_data =
    GenericData([Pair(0, 100), Pair(1, 1720056807332), Pair(2, 1720078407332)])

  let result = get_price(valid_price_data)

  result == 100
}
