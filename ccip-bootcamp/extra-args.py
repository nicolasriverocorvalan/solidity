from eth_abi.abi import encode

# Addresses of the XNFT.sol smart contracts
ethereum_sepolia_address = "0x27C97B7E4a3FE199b90b74115c0D70BbDeB5A433"
arbitrum_sepolia_address = "0xA32C97afA6B5a7Ca936A7aaeeaA1C2b58Bc75A7C"

# Chain selector for the Arbitrum Sepolia network
chain_selector = 3478487238524512106

# Encoded extra arguments value with 200,000 gas limit
ccip_extra_args = "0x97a657c90000000000000000000000000000000000000000000000000000000000030d40"

# Function to encode the gas limit
def encode_gas_limit(gas_limit):
    extra_args_bytes = encode(['uint256'], [gas_limit])
    return extra_args_bytes

# Example usage
gas_limit = 200000
encoded_bytes = encode_gas_limit(gas_limit)

# Print the results
print(f"Ethereum Sepolia Contract Address: {ethereum_sepolia_address}")
print(f"Arbitrum Sepolia Contract Address: {arbitrum_sepolia_address}")
print(f"Chain Selector: {chain_selector}")
print(f"Encoded Gas Limit: {encoded_bytes.hex()}")
print(f"CCIP Extra Args: {ccip_extra_args}")
