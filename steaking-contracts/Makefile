all :  remove install build

clean :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit

update :; forge update

compile :; forge compile

build :; forge build

test :; forge test

snapshot :; forge snapshot

format-sol :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

precommit :; forge fmt && git add .

scope :; cloc src/Steaking.vy --force-lang="Python"