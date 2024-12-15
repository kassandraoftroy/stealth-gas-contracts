# Load environment variables
source .env

# Deploy using script
forge script ./script/Deploy.s.sol:DeployScript \
--sig "deploy()" $CHAIN_ID \
--rpc-url $HTTP_RPC_URL --private-key $PRIVATE_KEY --slow -vvv \
--broadcast --legacy \
--with-gas-price 30000000000