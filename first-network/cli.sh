../bin/cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD

../bin/configtxgen -profile SampleMultiNodeEtcdRaft -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel  && ../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME


docker-compose -f docker-compose-cli.yaml -f docker-compose-etcdraft2.yaml up -d 



docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051"
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP"
docker exec -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"

export CHANNEL_NAME=mychannel

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

peer channel create -o orderer2.example.com:8050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel create -o orderer3.example.com:9050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel create -o orderer4.example.com:10050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel create -o orderer5.example.com:11050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

peer channel join -b mychannel.block

peer chaincode install -n mycc1 -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/


peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc1 -v 1.0 -c '{"Args":["init"]}' -P "AND ('Org1MSP.member','Org2MSP.member')"

peer chaincode instantiate -o orderer2.example.com:8050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc1 -v 1.0 -c '{"Args":["init"]}' -P "AND ('Org1MSP.member','Org2MSP.member')"


peer chaincode instantiate -o orderer3.example.com:9050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc1 -v 1.0 -c '{"Args":["init"]}' -P "AND ('Org1MSP.member','Org2MSP.member')"
