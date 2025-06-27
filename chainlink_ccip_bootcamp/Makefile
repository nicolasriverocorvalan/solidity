-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil deploy-nft-sepolia

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install smartcontractkit/ccip@ccip-develop --no-commit; forge install OpenZeppelin/openzeppelin-contracts@v4.0.0 --no-commit ; forge install foundry-rs/forge-std --no-commit; forge install smartcontractkit/chainlink-brownie-contracts --no-commit; forge install smartcontractkit/chainlink-local --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network arbitrum,$(ARGS)),--network arbitrum)
	NETWORK_ARGS := --rpc-url $(ARBITRUM_RPC_URL) --private-key $(ARBITRUM_PRIVATE_KEY) --broadcast -vvvv
endif

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv --legacy
endif

ifeq ($(findstring --network fuji,$(ARGS)),--network fuji)
	NETWORK_ARGS := --rpc-url $(FUJI_RPC_URL) --private-key $(FUJI_PRIVATE_KEY) --broadcast -vvvv
endif

deploy-sender:
	@forge script script/DeployProgrammableDefensiveTokenTransfersSender.s.sol $(NETWORK_ARGS)

deploy-receiver:
	@forge script script/DeployProgrammableDefensiveTokenTransfersReceiver.s.sol $(NETWORK_ARGS)

deploy-nft-sepolia:
	@CCIP_ROUTER_ADDRESS=0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59 \
	LINK_TOKEN_ADDRESS=0x779877A7B0D9E8603169DdbD7836e478b4624789 \
	CHAIN_SELECTOR=16015286601757825753 \
	NETWORK_NAME="Ethereum Sepolia" \
	forge script script/DeployXNFT.s.sol $(NETWORK_ARGS)

deploy-nft-arbitrum:
	@CCIP_ROUTER_ADDRESS=0x2a9c5afb0d0e4bab2bcdae109ec4b0c4be15a165 \
	LINK_TOKEN_ADDRESS=0xb1D4538B4571d411F07960EF2838Ce337FE1E80E \
	CHAIN_SELECTOR=3478487238524512106 \
	NETWORK_NAME="Arbitrum Sepolia" \
	forge script script/DeployXNFT.s.sol $(NETWORK_ARGS)

deploy-transfer-usdc-fuji:
	@forge script script/DeployTransferUSDC.s.sol $(NETWORK_ARGS)
