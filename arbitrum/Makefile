-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile

all: remove install build

clean  :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) --private-key $(ARBITRUM_SEPOLIA_PRIVATE_KEY) --broadcast -vvvv
endif

deploy:
	@forge script script/DeployPriceFeed.s.sol:DeployPriceFeed $(NETWORK_ARGS)
