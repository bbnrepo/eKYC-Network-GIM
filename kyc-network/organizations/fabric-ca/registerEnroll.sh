#!/bin/bash

function createSBI() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/sbi.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sbi.example.com/

  set -x
  fabric-ca-client enroll -u https://adminsbi:adminpw@localhost:7054 --caname ca-sbi --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbi.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbi.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbi.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbi.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-sbi --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-sbi --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null
  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-sbi --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-sbi --id.name sbiadmin --id.secret sbiadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/msp" --csr.hosts peer0.sbi.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls" --enrollment.profile tls --csr.hosts peer0.sbi.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/tlsca/tlsca.sbi.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/ca/ca.sbi.example.com-cert.pem"


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/msp" --csr.hosts peer1.sbi.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/msp/config.yaml"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls" --enrollment.profile tls --csr.hosts peer1.sbi.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/tlsca/tlsca.sbi.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbi.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/sbi.example.com/ca/ca.sbi.example.com-cert.pem"
  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/users/User1@sbi.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbi.example.com/users/User1@sbi.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sbiadmin:sbiadminpw@localhost:7054 --caname ca-sbi -M "${PWD}/organizations/peerOrganizations/sbi.example.com/users/Admin@sbi.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/sbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbi.example.com/users/Admin@sbi.example.com/msp/config.yaml"
}

function createICICI() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/icici.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/icici.example.com/

  set -x
  fabric-ca-client enroll -u https://adminicici:adminpw@localhost:8054 --caname ca-icici --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icici.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icici.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icici.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icici.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/icici.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-icici --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-icici --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-icici --id.name iciciadmin --id.secret iciciadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-icici -M "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/msp" --csr.hosts peer0.icici.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icici.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-icici -M "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls" --enrollment.profile tls --csr.hosts peer0.icici.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/icici.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icici.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/icici.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icici.example.com/tlsca/tlsca.icici.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/icici.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/icici.example.com/ca/ca.icici.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-icici -M "${PWD}/organizations/peerOrganizations/icici.example.com/users/User1@icici.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icici.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icici.example.com/users/User1@icici.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://iciciadmin:iciciadminpw@localhost:8054 --caname ca-icici -M "${PWD}/organizations/peerOrganizations/icici.example.com/users/Admin@icici.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/icici/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icici.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icici.example.com/users/Admin@icici.example.com/msp/config.yaml"
}

function createRBI() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/rbi.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rbi.example.com/

  set -x
  fabric-ca-client enroll -u https://adminrbi:adminpw@localhost:11054 --caname ca-rbi --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-rbi.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-rbi.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-rbi.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-rbi.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-rbi --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-rbi --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-rbi --id.name rbiadmin --id.secret rbiadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-rbi -M "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/msp" --csr.hosts peer0.rbi.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-rbi -M "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls" --enrollment.profile tls --csr.hosts peer0.rbi.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/rbi.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/tlsca/tlsca.rbi.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/rbi.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/rbi.example.com/ca/ca.rbi.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-rbi -M "${PWD}/organizations/peerOrganizations/rbi.example.com/users/User1@rbi.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rbi.example.com/users/User1@rbi.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://rbiadmin:rbiadminpw@localhost:11054 --caname ca-rbi -M "${PWD}/organizations/peerOrganizations/rbi.example.com/users/Admin@rbi.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/rbi/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/rbi.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/rbi.example.com/users/Admin@rbi.example.com/msp/config.yaml"
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
