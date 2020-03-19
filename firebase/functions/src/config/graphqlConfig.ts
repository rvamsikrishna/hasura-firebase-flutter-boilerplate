import * as functions from "firebase-functions";

export const graphQLHost = functions.config().hasura.url;
export const hasuraAdminSecretKey = functions.config().hasura.adminsecret;
