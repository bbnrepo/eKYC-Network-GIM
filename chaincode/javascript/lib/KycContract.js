'use strict';

const { Contract } = require('fabric-contract-api');

class KYCContract extends Contract {

    async InitKyc(ctx) {
        // Initialization function (no action needed in this example)
    }

    async CreateCustomer(ctx, customerID, name, dob, bank, mobile) {
        const customerBytes = await ctx.stub.getState(customerID);
        if (customerBytes && customerBytes.length > 0) {
            throw new Error(`The customer already exists for user ${name}`);
        }

        const clientOrgID = ctx.clientIdentity.getMSPID();

        const customer = {
            docType: "customer",
            customerID,
            name,
            dob,
            kycConsent: false,
            bank,
            mobile,
            createrOrg: clientOrgID,
            latestTransaction: ctx.stub.getTxID(),
        };

        await ctx.stub.putState(customerID, Buffer.from(JSON.stringify(customer)));
        return customer;
    }

    async GetCustomer(ctx, customerID) {
        const clientOrgID = ctx.clientIdentity.getMSPID();

        const customerBytes = await ctx.stub.getState(customerID);
        if (!customerBytes || customerBytes.length === 0) {
            throw new Error(`The asset ${customerID} does not exist`);
        }

        const customer = JSON.parse(customerBytes.toString());
        const kycConsentStatus = customer.kycConsent;
        const createrOrg = customer.createrOrg;

        if (!kycConsentStatus) {
            if (createrOrg !== clientOrgID) {
                throw new Error("Customer consent is required");
            }
        }

        return customer;
    }

    async GetConsent(ctx, customerID) {
        let customerBytes = await ctx.stub.getState(customerID);
        if (!customerBytes || customerBytes.length === 0) {
            throw new Error(`The asset ${customerID} does not exist`);
        }

        let customer = JSON.parse(customerBytes.toString());
        customer.kycConsent = true;

        await ctx.stub.putState(customerID, Buffer.from(JSON.stringify(customer)));
        return customer;
    }

    async UpdateCustomer(ctx, customerID, newMobile) {
        let customerBytes = await ctx.stub.getState(customerID);
        if (!customerBytes || customerBytes.length === 0) {
            throw new Error(`The asset ${customerID} does not exist`);
        }

        let customer = JSON.parse(customerBytes.toString());
        customer.mobile = newMobile;

        await ctx.stub.putState(customerID, Buffer.from(JSON.stringify(customer)));
        return customer;
    }

    async QueryAllCustomers(ctx) {
        const iterator = await ctx.stub.getStateByRange('', '');

        const results = [];
        while (true) {
            const result = await iterator.next();

            if (result.value && result.value.value.toString()) {
                const customer = JSON.parse(result.value.value.toString());
                const queryResult = { key: result.value.key, record: customer };
                results.push(queryResult);
            }

            if (result.done) {
                await iterator.close();
                return results;
            }
        }
    }
}

module.exports = KYCContract;
