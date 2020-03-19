import ApolloClient from "apollo-boost";
import fetch from "cross-fetch";
import { graphQLHost, hasuraAdminSecretKey } from "../../config/graphqlConfig";

export const gqlClent = new ApolloClient({
  uri: graphQLHost,
  fetch: fetch,
  request: (operation): void => {
    operation.setContext({
      headers: {
        "x-hasura-admin-secret": hasuraAdminSecretKey
      }
    });
  }
});
