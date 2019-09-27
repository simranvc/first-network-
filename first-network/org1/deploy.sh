docker stack deploy -c ca.yaml ca_org1

docker stack deploy -c orderer.yaml orderer_org1

docker stack deploy -c orderer2.yaml orderer2_org1

docker stack deploy -c orderer3.yaml orderer3_org1

docker stack deploy -c peer0.yaml peer0_org1

docker stack deploy -c peer1.yaml peer1_org1
