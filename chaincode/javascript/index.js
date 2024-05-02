/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const KYCContract = require('./lib/kyccontract');

module.exports.KYCContract = KYCContract;
module.exports.contracts = [ KYCContract ];
