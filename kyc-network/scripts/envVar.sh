#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SBI_CA=${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer0.sbi.example.com/tls/ca.crt
export PEER1_SBI_CA=${PWD}/organizations/peerOrganizations/sbi.example.com/peers/peer1.sbi.example.com/tls/ca.crt
export PEER0_ICICI_CA=${PWD}/organizations/peerOrganizations/icici.example.com/peers/peer0.icici.example.com/tls/ca.crt
export PEER0_RBI_CA=${PWD}/organizations/peerOrganizations/rbi.example.com/peers/peer0.rbi.example.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="SBIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SBI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sbi.example.com/users/Admin@sbi.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="SBIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_SBI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sbi.example.com/users/Admin@sbi.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="ICICIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ICICI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/icici.example.com/users/Admin@icici.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="RBIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RBI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/rbi.example.com/users/Admin@rbi.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.sbi.example.com:7051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer1.sbi.example.com:8051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.icici.example.com:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.rbi.example.com:11051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
# parsePeerConnectionParameters() {
#   PEER_CONN_PARMS=()
#   PEERS=""
#   while [ "$#" -gt 0 ]; do
#     setGlobals $1
#     PEER="peer0.org$1"
#     ## Set peer addresses
#     if [ -z "$PEERS" ]
#     then
# 	PEERS="$PEER"
#     else
# 	PEERS="$PEERS $PEER"
#     fi
#     PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
#     ## Set path to TLS certificate
#     CA=PEER0_ORG$1_CA
#     TLSINFO=(--tlsRootCertFiles "${!CA}")
#     PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
#     # shift by one to get to the next organization
#     shift
#   done
# }

parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    local USING_ORG=""
    if [ -z "$OVERRIDE_ORG" ]; then
      USING_ORG=$1
    else
      USING_ORG="${OVERRIDE_ORG}"
    fi
    
    if [ $USING_ORG -eq 1 ]; then
      PEER="peer0.sbi"
      CA=PEER0_SBI_CA
    elif [ $USING_ORG -eq 2 ]; then
      PEER="peer0.icici"
      CA=PEER0_ICICI_CA
    elif [ $USING_ORG -eq 3 ]; then
      PEER="peer0.rbi"
      CA=PEER0_RBI_CA
    elif [ $USING_ORG -eq 4 ]; then
      PEER="peer1.sbi"
      CA=PEER1_SBI_CA
    else
      errorln "ORG Unknown"
    fi 
    # PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	    PEERS="$PEER"
    else
	    PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    # CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
