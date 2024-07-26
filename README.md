# Oracle Integration in Aiken

This repository demonstrates how to integrate oracles into Cardano smart contracts using the Aiken programming language. It includes an oracle datum module and will feature example implementations, such as a betting contract, to showcase practical applications of oracle data in Cardano dApps.

## Project Structure

- `lib/`: Houses the core oracle integration module.
  - `oracle_datum.ak`: Contains the oracle datum definitions, functions, and associated tests.
  - `types.ak`: Defines common types used across the project.
- `validators/`: Will contain the validator scripts, including the betting contract (to be implemented).
- `aiken.toml`: Project configuration file.
- `README.md`: This file, providing project overview and instructions.

## Oracle Datum Module

The oracle datum module in `lib/oracle_datum.ak` provides:

- Definitions for oracle data structures
- Functions for handling oracle data
- Tests for the oracle datum functionality

All tests for the oracle datum are included directly in the `oracle_datum.ak` file, allowing for easy reference and maintenance alongside the implementation.

## Building

To build the project, run:

```sh
aiken build
```

This will compile all Aiken modules and generate the necessary Plutus scripts.

## Testing

Since tests are included in the `oracle_datum.ak` file, you can run them using:

```sh
aiken check
```

To run tests matching a specific string (e.g., "oracle"), use:

```sh
aiken check -m oracle
```

## Usage

To use the oracle integration in your own project:

1. Copy the `lib/oracle_datum.ak` file to your project's `lib/` directory.
2. Import the oracle module in your validator:

```aiken
use oracle_datum

validator {
  fn example(datum: Data, redeemer: Data, context: Data) -> Bool {
    // Use oracle functions here
    // e.g., oracle_datum.get_price(datum)
  }
}
```

## Documentation

Generate HTML documentation for the project:

```sh
aiken docs
```

## Contributing

We welcome contributions! Please feel free to submit a Pull Request.