export ETHERSCAN_API_KEY=4WR5EQMZ6GVGHBRPQIJJPUMV3K16HHHYPQ && \
    forge create src/DcaFactory.sol:DcaFactory \
        --rpc-url https://rpc-mumbai.maticvigil.com/ \
        --private-key 0x1f51ad8ae1b770f7856e19de62a3bfdb0409571f735531b11a06a19f0fa0920d \
        --constructor-args 0x7E206B547953BcE9a94B80c28F3f8a869e2D82f9 0x326C977E6efc84E512bB9C30f76E30c160eD06FB \
        --verify
