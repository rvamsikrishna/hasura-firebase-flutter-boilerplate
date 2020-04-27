A boilerplate to setup up a flutter app with hasura for graphQL APIs and firebase for user management and providing custom JWTs for authorization.

## Setup

### Hasura

Setup a Hasura GraphQL engine and Postgres running on Heroku. Follow the instructions [here](https://hasura.io/docs/1.0/graphql/manual/getting-started/heroku-simple.html).

Secure your graphQL endpoint by setting the `HASURA_GRAPHQL_ADMIN_SECRET` environment variable in Heroku dashboard. See complete instructions [here](https://hasura.io/docs/1.0/graphql/manual/deployment/heroku/securing-graphql-endpoint.html#heroku-secure).

Enable JWT mode by setting `HASURA_GRAPHQL_JWT_SECRET` environment variable from the heroku dashboard. The JWT Config to be used in env HASURA_GRAPHQL_JWT_SECRET for firebase can be generated using: https://hasura.io/jwt-config.
The config generated from the above page can be directly pasted in for the value of `HASURA_GRAPHQL_JWT_SECRET` in config vars under heroku dashboard.

### Firebase

1. Create a new firebase project in firebase console.

2. Under **Authentication>Sign-in Method** enable Email/Password and Google providers.

3. Setup a Firestore database.

4. Setup firebase config variables:

   1. change into firebase/functions directory.

      ```console
      cd firebase
      cd functions
      npm install
      ```

   2. set variable in command line.

      ```console
      firebase functions:config:set hasura.url=<YOUR-GRAPHQL-ENDPOINT> hasura.adminsecret=<YOUR-ADMIN-SECRET>
      ```

   3. Add the created firebase project. In command line use the following command:

   ```console
   firebase use --add
   ```

   Then select the newly create firebase project.

   4. Deploy the functions.

      ```console
      npm run deploy
      ```

### Flutter

Add firebase to your flutter app. For complete instructions follow:

- Android - [here](https://firebase.google.com/docs/flutter/setup?platform=android)
- iOS - [here](https://firebase.google.com/docs/flutter/setup?platform=ios)
