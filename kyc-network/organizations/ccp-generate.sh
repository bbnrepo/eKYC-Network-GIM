#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=sbi
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/sbi.example.com/tlsca/tlsca.sbi.example.com-cert.pem
CAPEM=organizations/peerOrganizations/sbi.example.com/ca/ca.sbi.example.com-cert.pem
ORGMSP=SBI

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/sbi.example.com/connection-sbi.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/sbi.example.com/connection-sbi.yaml

ORG=icici
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/icici.example.com/tlsca/tlsca.icici.example.com-cert.pem
CAPEM=organizations/peerOrganizations/icici.example.com/ca/ca.icici.example.com-cert.pem
ORGMSP=ICICI

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/icici.example.com/connection-icici.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/icici.example.com/connection-icici.yaml

ORG=rbi
P0PORT=11051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/rbi.example.com/tlsca/tlsca.rbi.example.com-cert.pem
CAPEM=organizations/peerOrganizations/rbi.example.com/ca/ca.rbi.example.com-cert.pem
ORGMSP=RBI

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rbi.example.com/connection-rbi.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGMSP)" > organizations/peerOrganizations/rbi.example.com/connection-rbi.yaml
