#!/bin/bash

function createUBA() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/uba.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/uba.example.com/

  set -x
  fabric-ca-client enroll -u https://adminuba:adminpw@localhost:7054 --caname ca-uba --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uba.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uba.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uba.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uba.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/uba.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-uba --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-uba --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null
  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-uba --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-uba --id.name ubaadmin --id.secret ubaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/msp" --csr.hosts peer0.uba.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls" --enrollment.profile tls --csr.hosts peer0.uba.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/tlsca/tlsca.uba.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer0.uba.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/ca/ca.uba.example.com-cert.pem"


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/msp" --csr.hosts peer1.uba.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/msp/config.yaml"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls" --enrollment.profile tls --csr.hosts peer1.uba.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/tlsca/tlsca.uba.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uba.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uba.example.com/peers/peer1.uba.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uba.example.com/ca/ca.uba.example.com-cert.pem"
  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/users/User1@uba.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uba.example.com/users/User1@uba.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://ubaadmin:ubaadminpw@localhost:7054 --caname ca-uba -M "${PWD}/organizations/peerOrganizations/uba.example.com/users/Admin@uba.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uba/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uba.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uba.example.com/users/Admin@uba.example.com/msp/config.yaml"
}

function createGTB() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/gtb.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gtb.example.com/

  set -x
  fabric-ca-client enroll -u https://admingtb:adminpw@localhost:8054 --caname ca-gtb --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gtb.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gtb.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gtb.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gtb.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-gtb --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-gtb --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-gtb --id.name gtbadmin --id.secret gtbadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gtb -M "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/msp" --csr.hosts peer0.gtb.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gtb -M "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls" --enrollment.profile tls --csr.hosts peer0.gtb.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/gtb.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/tlsca/tlsca.gtb.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/gtb.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/peers/peer0.gtb.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/gtb.example.com/ca/ca.gtb.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-gtb -M "${PWD}/organizations/peerOrganizations/gtb.example.com/users/User1@gtb.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gtb.example.com/users/User1@gtb.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gtbadmin:gtbadminpw@localhost:8054 --caname ca-gtb -M "${PWD}/organizations/peerOrganizations/gtb.example.com/users/Admin@gtb.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gtb/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gtb.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gtb.example.com/users/Admin@gtb.example.com/msp/config.yaml"
}

function createCBN() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/cbn.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/cbn.example.com/

  set -x
  fabric-ca-client enroll -u https://admincbn:adminpw@localhost:11054 --caname ca-cbn --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-cbn.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-cbn.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-cbn.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-cbn.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-cbn --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-cbn --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-cbn --id.name cbnadmin --id.secret cbnadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-cbn -M "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/msp" --csr.hosts peer0.cbn.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-cbn -M "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls" --enrollment.profile tls --csr.hosts peer0.cbn.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/cbn.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/tlsca/tlsca.cbn.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/cbn.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/peers/peer0.cbn.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/cbn.example.com/ca/ca.cbn.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-cbn -M "${PWD}/organizations/peerOrganizations/cbn.example.com/users/User1@cbn.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cbn.example.com/users/User1@cbn.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://cbnadmin:cbnadminpw@localhost:11054 --caname ca-cbn -M "${PWD}/organizations/peerOrganizations/cbn.example.com/users/Admin@cbn.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/cbn/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cbn.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cbn.example.com/users/Admin@cbn.example.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp" --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls" --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
